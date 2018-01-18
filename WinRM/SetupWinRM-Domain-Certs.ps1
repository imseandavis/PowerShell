#Define The Server Thats Being Setup
Do { $MasterOrSlave = Read-Host "Are You Setting Up A Master or Slave Server? (Master/Slave)" }
Until (($MasterOrSlave -eq 'Master') -OR ($MasterOrSlave -eq 'Slave'))

#Get Master Server IP
If ($MasterOrSlave -eq 'master')
{
  #Get Master FQDN Automatically
  $MasterFQDN = $((GWMI Win32_ComputerSystem).Name + "." + (GWMI Win32_ComputerSystem).Domain).ToLower()
  
  #Get Slave Server Manually
  $SlaveFQDN = Read-Host "Slave Server Fully Qualified Domain Name"
}
Else
{
  #Get Manually
  $MasterFQDN = Read-Host "Master Server Fully Qualified Domain Name"
  
  #Get Slave Server Automatically
  $SlaveFQDN = $((GWMI Win32_ComputerSystem).Name + "." + (GWMI Win32_ComputerSystem).Domain).ToLower()
}

Switch ($MasterOrSlave)
{
	"master"
	{
		#Import Slave Server Certificate (Repeat This Step For All Slave EndPoints, This Should Be Automated at Some Point
		Read-Host "Copy the Cert From The Master server Into The C:\Temp Folder And Click Any Key To Continue"
		Write-Host "Importing Master Server Certificate..."
		$SlaveCert = Import-Certificate -Filepath "C:\temp\cert" -CertStoreLocation "Cert:\LocalMachine\Root"
		
		#Enable Remoting
		Write-Host "Enabling WinRM Remoting...`n"
		try
		{
			Enable-PSRemoting -SkipNetworkProfileCheck -Force -ErrorAction Stop | Out-Null
		}
		catch
		{
			Write-Host "WinRM Remoting Could Not Be Enabled, The Following Error Was Reported:`n$($Error[0].Exception.Message)"
			Break
		}

		#Remove Http Listener
		Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse

		#Disable HTTP Firewall Rule
		Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

		#Test Remote Service Connectivity
		Write-Host "Testing Service Connectivity..."
		try
		{
			Test-WSMan -Computer $SlaveFQDN  -ErrorAction Stop | Out-Null
			Write-Host -Foreground Green "-Passed!`n"
		}
		catch
		{
			Write-Host "An Error While Testing The Remote WinRM Service, The Following Error Was Reported:`n$($Error[0].Exception.Message)`n Please correct the issue and try again!"
			Break
		}
		
		#Test Remote Command
		try
		{
			Write-Host "Testing Remote Command - Gather ServerInfo..." 
			Write-Host "-Get Server Name"
			$SlaveServerName = Invoke-Command -Computer $SlaveFQDN -ScriptBlock {(Get-CimInstance Win32_ComputerSystem).Name}
			Write-Host "-Get Server GUID"
			$SlaveServerGUID = Invoke-Command -Computer $SlaveInternalFQDN -ScriptBlock {(Get-CimInstance Win32_ComputerSystemProduct).UUID }
			Write-Host "-Get Server OS Disk Info"
			$SlaveServerDiskInfo = Invoke-Command -Computer $SlaveInternalFQDN -ScriptBlock { Get-WMIObject Win32_LogicalDisk | Where-Object{$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}} } 
			Write-Host -Foreground Green "-Passed!`n"
			Write-Host "Slave Server Info:`n Server Name: $SlaveServerName`n GUID: $SlaveServerGUID`n OS Disk Info:`n Total Size (GB): $($SlaveServerDiskInfo | Select -First 1 | Select 'Size (GB)' -ExpandProperty 'Size (GB)')`n Percent Free: $($SlaveServerDiskInfo | Select -First 1 | Select PercentFree -ExpandProperty PercentFree)%`n"
		}
		catch
		{
			Write-Host "An Error While Connecting To The Remote WinRM Service, The Following Error Was Reported:`n$($Error[0].Exception.Message)`n Please ensure this script has been successfully ran against the slave server specified and try again!"
			Break
		}
	}

	"slave"
	{
		#Create Self Signed Certificate
		$SlaveCert = New-SelfSignedCertificate -DnsName $MasterFQDN -CertStoreLocation Cert:\LocalMachine\My

		#Export Slave Certificate
		Write-Host "Exporting The Master Cert..."
		$ExportedSlaveCert = Export-Certificate -Cert $SlaveCert -FilePath C:\Temp\Cert
		Write-Host "Your Cert Has Been Exported To: $($ExportedSlaveCert.FullName)"

		#Enable Remoting
		Write-Host "Enabling WinRM Remoting...`n"
		try
		{
			Enable-PSRemoting -Force -ErrorAction Stop | Out-Null
		}
		catch
		{
			Write-Host "WinRM Remoting Could Not Be Enabled, The Following Error Was Reported:`n$($Error[0].Exception.Message)"
			Break
		}
    
		#Remove Http Listener
		Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse

		#Disable HTTP Firewall Rule
		Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

		#Add HTTPS Listener
		try
		{
		New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $($SlaveCert.Thumbprint) –Force
		}
		catch
		{
		"An HTTPS Listener Was Already Found! You can only have one HTTPS WinRM listener, please delete the listener and run this script again!"
		Break
		}

		#Turn On HTTPS Firewall Rule
		try
		{
		New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP -ErrorAction Stop | Out-Null
		}
		catch
		{
		"Rule already Existed, Skipping..."
		}

		#Do you want to setup compatibility listener to do https over 443?
		#If Yes
		Do {$EnableCompatibleListener = Read-Host "Do You Want To Enable Compatible HTTPS Listener For Port 443? (y/n)"}
		Until (($EnableCompatibleListener -eq 'y') -Or ($EnableCompatibleListener -eq 'n'))
		If ($EnableCompatibleListener -eq 'y')
		{
		#Turn Compatibility Listener On
		Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value $True

		#Set Network Connection Profile To Private Or This Won't Work
		Set-NetConnectionProfile -NetworkCategory Private
		}

		#Test Local Connectivity
		Write-Host "Testing Local Service Connectivity..."
		try
		{
			Test-WSMan -ErrorAction Stop | Out-Null
			Write-Host -Foreground Green "-Passed!`n"
		}
		catch
		{
			Write-Host "An Error While Testing The Local WinRM Service, The Following Error Was Reported:`n$($Error[0].Exception.Message)`n Please correct the issue and try again!`n"
			Break
		}
	}
	
	default {"Error Occurred! Please Restart Script!"; Break}
}
