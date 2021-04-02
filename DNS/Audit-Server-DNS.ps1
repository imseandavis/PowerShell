Function Audit-PrepServerDNS {

	#Import AD Module
	Import-Module ActiveDirectory

	#Define Variables
	$DNSList = @()
  
  #Enter Your Domain Extension Here
  $DNSDomain = ".local" 
	
	#Get All Servers
	$ServerList = (Get-ADComputer -Filter {(enabled -eq $true) -and (OperatingSystem -Like "Windows Server*")})

	#Notify User About How Many Servers Are Being Processed
	$ServerCount = ($ServerList | Measure-Object).Count

	#Loop Through The List
	ForEach ($Server in $ServerList) {
	
		Write-Progress -Activity "$ServerCount Servers Remaining For Processing" -Status "Processing $Server"
		$ServerCount = $ServerCount - 1

		#Attempt To Validate The Server's Existence
		If(Test-Connection -ComputerName $Server.DNSHostName -Count 1 -Quiet){
	
			#Check Via WMI And Get Any IPv4 NIC's Information
			try{
				$NICList = $(Get-WMIObject Win32_NetworkAdapterConfiguration -Computer $Server.DNSHostName -Filter "IPEnabled=True" -EA Stop | Select IPAddress, DNSServerSearchOrder | Where {$_.IPAddress -like "*.*.*.*"})
				
				ForEach ($NIC in $NICList){
					$NewBuild = "" | Select Name, OU, IP, DNS
					$NewBuild.Name =  $Server.DNSHostName.TrimEnd($DNSDomain)
					$NewBuild.OU = $Server.DistinguishedName
					$NewBuild.IP = $NIC.IPAddress | Select -First 1
					$NewBuild.DNS = $NIC.DNSServerSearchOrder -join ", "
					$DNSList += $NewBuild
				}
			}
			catch{
				Write-Warning "$($Server.Name) Is Ping-able, But Settings Could Not Be Retrieved! Please Manually Verify."
				$NewBuild = "" | Select Name, OU, IP, DNS
				$NewBuild.Name = $Server.DNSHostName.TrimEnd($DNSDomain)
				$NewBuild.OU = $Server.DistinguishedName
				$NewBuild.IP = $([System.Net.Dns]::GetHostAddresses($Server.DNSHostName)).IPAddressToString
				$NewBuild.DNS = "Could Not Be Retrieved"
				$DNSList += $NewBuild
			}
		}
		Else{
			Write-Warning "$($Server.Name) Was Unreachable! Please Verify This Server Exists."
			
			#Write Query Info To PSObject
			$NewBuild = "" | Select Name, OU, IP, DNS
			$NewBuild.Name =  $Server.DNSHostName.TrimEnd($DNSDomain)
			$NewBuild.OU = $Server.DistinguishedName
			$NewBuild.IP = "No Response"
			$NewBuild.DNS = "No Response"
			$DNSList += $NewBuild
		}
	}
	
	#Output The Final Lists
	$DNSList | Export-CSV -NoTypeInformation C:\DNSList-BaseConfig-PREP.csv
}
