#Region Change Log
###################################################
#6/26/2013: Created Module - Sean Davis
#6/26/2013: Added Function Get-ServerDiskSpace - Sean Davis
###################################################
#endregion


#Region Variables
###################################################
$ScriptName = $((($MyInvocation.MyCommand.name) -split '.psm1')[0]) #Get Current Script Name
$global:Domain = (Get-WmiObject Win32_ComputerSystem).Domain #Get Server Domain
$global:CurrentServer = "$((Get-WmiObject Win32_ComputerSystem).DNSHostName).$Domain" #Get Current Server Name
$SMTPserver = "" #Configure Server SMTP Relay Server
$LogFile = "C:\Scripts\$ScriptName.log" #Configure Log File Name
###################################################
#endregion


#Region Functions
###################################################
Function Get-HostUptime {
       param ([string]$ComputerName)
       $Uptime = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ComputerName
       $LastBootUpTime = $Uptime.ConvertToDateTime($Uptime.LastBootUpTime)
       $Time = (Get-Date) - $LastBootUpTime
       Return '{0:00} Days, {1:00} Hours, {2:00} Minutes, {3:00} Seconds' -f $Time.Days, $Time.Hours, $Time.Minutes, $Time.Seconds
}

Function Get-InstalledSoftware {

	[cmdletBinding()]
	param(
		[parameter(Mandatory=$true, HelpMessage="Computer Name To Query")]
		$Computer
	)

	#Create The Object To Hold The Info
	$Software = @()

	#Define the variable to hold the location of Currently Installed Programs
	$UninstallKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall" 

    #Create An Instance Of The Registry And Drill Down To The Uninstall Key And Enumerate The Subkeys (Installed Program GUIDS)
    try{
		$InstalledProgramGUIDS=(([microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine', $Computer)).OpenSubKey($UninstallKey)).GetSubKeyNames()
	}
	catch{
		$global:UnableToContact += $Computer
	}
		
    #Open each Subkey and use GetValue Method to return the required values for each
    ForEach($Program in $InstalledProgramGUIDS){
        $CurrentKey = (([microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine', $Computer)).OpenSubKey("$UninstallKey\\$Program"))
        $InstalledItem = New-Object PSObject
        $InstalledItem | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($CurrentKey.GetValue("DisplayName"))
		$InstalledItem | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($CurrentKey.GetValue("DisplayVersion"))
        $InstalledItem | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($CurrentKey.GetValue("Publisher"))
		$InstalledItem | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($CurrentKey.GetValue("InstallLocation"))
        $Software += $InstalledItem
    } 
	return $Software
}

Function Get-ComputerSessions {

	[cmdletbinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
            [string[]]$Computer
	)
	
	#Create The Object To Hold The Info
    $SessionReport = @()

    #Query The Sessions
	$Sessions = Query Session /Server:$Computer | Select -Skip 1
     
	#Enumerate The Data And Populate The Object
	ForEach($Session in $Sessions){
                $User = New-Object PSObject
				$User | Add-Member -MemberType NoteProperty -Name UserName -Value $Session.Substring(19,20).Trim()
                $User | Add-Member -MemberType NoteProperty -Name State -Value $Session.Substring(48,8).Trim()
                $SessionReport += $User
    }
	return $SessionReport | Where {$_.Username -ne ""}
}

Function Get-ServerInfo{
	
	[cmdletBinding()]
	param(
		[parameter(Mandatory=$true, HelpMessage="List Of Computers To Query")]
		$ComputerList
	)
	
	#Create The Variable To Hold Out Info
	$Info = @()
	
	#Loop Through The Computer List
	ForEach($Computer in $ComputerList){
	
		#Check To See If The Host Is Alive
		If($(Test-Connection $Computer -Count 1 -ErrorAction SilentlyContinue) -ne $null){

			$HostInfo = New-Object System.Object
			$HostInfo | Add-Member -MemberType NoteProperty -Name Name -Value $((Get-WmiObject Win32_ComputerSystem -Computer $Computer).Name)
			$HostInfo | Add-Member -MemberType NoteProperty -Name SerialNumber -Value $((Get-WMIObject -Class Win32_BIOS -Computer $Computer).SerialNumber)
	
			#Calculate Machine Type (Physical or Virtual)
			If($((Get-WmiObject Win32_ComputerSystem -Computer $Computer).Model) -like "*VMware*"){
				$HostInfo | Add-Member -MemberType NoteProperty -Name MachineType -Value "Virtual Machine"
			}
			Else{
				$HostInfo | Add-Member -MemberType NoteProperty -Name MachineType -Value "Physical"
			}
			
			#Wrote This In To Prevent Blank Values If The Server Was Idle
			If($((Get-WmiObject Win32_Processor -Computer $Computer).LoadPercentage) -eq $null){
				$HostInfo | Add-Member -MemberType NoteProperty -Name AverageCPULoadPercent -Value 1
			}
			Else{
				$HostInfo | Add-Member -MemberType NoteProperty -Name AverageCPULoadPercent -Value $((Get-WmiObject Win32_Processor -Computer $Computer).LoadPercentage)
			}
			$HostInfo | Add-Member -MemberType NoteProperty -Name SystemUptime -Value $(Get-HostUptime -Computer $Computer)
			$HostInfo | Add-Member -MemberType NoteProperty -Name OS -Value $((Get-WmiObject Win32_OperatingSystem -Computer $Computer).Caption)
			$HostInfo | Add-Member -MemberType NoteProperty -Name ServicePack -Value $((Get-WmiObject Win32_OperatingSystem -Computer $Computer).CSDVersion)
			$HostInfo | Add-Member -MemberType NoteProperty -Name Platform -Value $((Get-WmiObject Win32_ComputerSystem -Computer $Computer).SystemType).Split(" ")[0]
			$HostInfo | Add-Member -MemberType NoteProperty -Name MemoryTotalGB -Value $([Math]::Round($((Get-WmiObject Win32_ComputerSystem -Computer $Computer).TotalPhysicalMemory) / 1024 /1024 / 1024))
			$HostInfo | Add-Member -MemberType NoteProperty -Name MemoryFreePercent -Value $([Math]::Round($((Get-WmiObject Win32_OperatingSystem -Computer $Computer).FreePhysicalMemory)/$((Get-WmiObject Win32_OperatingSystem -Computer $Computer).TotalVisibleMemorySize)*100))
			$HostInfo | Add-Member -MemberType NoteProperty -Name MemoryUsedPercent -Value $([Math]::Round($(100 - $((Get-WmiObject Win32_OperatingSystem -Computer $Computer).FreePhysicalMemory)/$((Get-WmiObject Win32_OperatingSystem -Computer $Computer).TotalVisibleMemorySize)*100)))
			
			#Get All Fixed Disk Drives And Usage
			$HostInfo | Add-Member -MemberType NoteProperty -Name DiskStats -Value $(Get-WmiObject Win32_LogicalDisk -Computer $Computer | Where {$_.DriveType -eq "3"} | Select DeviceID, FreeSpace, Size, @{Name = "PercentUsed"; Expression = {$([Math]::Round($(100 - $($_.FreeSpace)/$($_.Size) * 100)))}}, @{Name = "PercentFree"; Expression = {$([Math]::Round($($_.FreeSpace)/$($_.Size) * 100))}}, VolumeName)
			
			#Get Network Adapter Information
			$NetworkDevices = Get-WMIObject Win32_NetworkAdapterConfiguration -Computer $Computer | Where {$_.IPEnabled -eq $True}
			$HostInfo | Add-Member -MemberType NoteProperty -Name NetworkAdapters -Value $($NetworkDevices | Select Description, IPAddress, IPSubnet, DefaultIPGateway, DNSServerSearchOrder, DNSDomainSuffixSearchOrder, MACAddress)
			If(($NetworkDevices.Description -like "*basp*") -or ($NetworkDevices.Description -like "*team*")) {
				Write-Warning "Network Teaming Found, Due To System Limitations, Please Validate All NICS And Settings Manually"
			}
			
			#Get iSCSI Info
			$iSCSIDrives = Get-WmiObject -Namespace ROOT\WMI -Class MSiSCSIInitiator_SessionClass -Computer $Computer
			$HostInfo | Add-Member -MemberType NoteProperty -Name iSCSIConnections -Value $($iSCSIDrives | Select InitiatorName, TargetName, SessionID, Devices)
			If($iSCSIDrives -ne $null) {
				Write-Warning "iSCSI Volumes Found, Due To System Limitations, Please Validate All iSCSI Information Manually"
			}

			#Gather Active Sessions
			$HostInfo | Add-Member -MemberType NoteProperty -Name ActiveSessions -Value $(Get-ComputerSessions -Computer $Computer | Where {$_.Username -ne ""} | Select Username, State)
			
			#Gather All Services
			$HostInfo | Add-Member -MemberType NoteProperty -Name Services -Value $(Get-Service -ComputerName $Computer)
						
			#Gather All Network Shares
			$HostInfo | Add-Member -MemberType NoteProperty -Name NetworkShares -Value $(Get-WMIObject Win32_Share -Computer $Computer)

			#Gather Server Roles and Features (Works For Only Local Calls)
			#try{
			#	$Session - Enter-PSSession -Computer $Computer #Attempt To Establish A Connection With The Remote Server
			#}
			#catch{
			#	Write-Warning "Could Not Remotely Connect To $Computer, Due To System Limitations, Please Validate All Installed Roles iSCSI Information Manually"
			#}
			#$ServerRoles = Invoke-Command -ComputerName tlxdocimgs01 -ScriptBlock {Get-WindowsFeature}
			#If($iSCSIDrives -ne $null) {
			#	Write-Warning "iSCSI Volumes Found, Due To System Limitations, Please Validate All iSCSI Information Manually"
			#}
			#$HostInfo | Add-Member -MemberType NoteProperty -Name ServerRoles -Value $(Get-WindowsFeature | Where {$_.Installed -eq $true} | Select Name)
			
			#Gather Installed Software
			$HostInfo | Add-Member -MemberType NoteProperty -Name InstalledSoftware -Value $(Get-InstalledSoftware -Computer $Computer)
			
			#Write Gathered Information Into Info Object
			$Info += $HostInfo
		}
		Else{
			Write-Warning "Information For $Computer Could Not Be Retrieved"
		}
	}
	
	#Switch ($Report.ToUpper())
	#{
	#	HTML {"Export To HTML"}
	#	EXCEL {"Export To Excel File"}
	#	TEXT {"Export To text File"}
	#	$Default {"Improper Switch Used. Please Use HTML, Excel, or Text"}		
	#}
	
	return $Info
}
###################################################
#endregion