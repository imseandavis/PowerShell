#Define The Server Thats Being Setup
Do { $MasterOrSlave = Read-Host "Are You Setting Up A Master or Slave Server? (Master/Slave)" }
Until (($MasterOrSlave -eq 'Master') -OR ($MasterOrSlave -eq 'Slave'))

#Get Master Server IP
Do { $MasterInternalIP = Read-Host "Master Server Internal IP" }
Until ($MasterInternalIP -as [ipaddress])

#Get Slave Server IP
Do { $SlaveInternalIP = Read-Host "Slave Server Internal IP" }
Until ($SlaveInternalIP -as [ipaddress])


Switch ($MasterOrSlave)
{
	"master"
	{
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
		
		#Configure Remoting
		Write-Host "Configuring Remoting Master Server Remoting Options..."
		try
		{
			Write-Host "-Service Basic Auth - True"
			Set-Item WSMan:\localhost\Service\Auth\Basic -Value $True
			
			Write-Host "-Service Allow Unencrypted Traffic - True"
			Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $True
			
			Write-Host "-Client Basic Auth - True"
			Set-Item WSMan:\localhost\Client\Auth\Basic -Value $True
			
			Write-Host "-Client Allow Unencrypted Traffic - True`n"
			Set-Item WSMan:\localhost\Client\AllowUnencrypted -Value $True
		}
		catch
		{
			Write-Host "An Error While Configuring The WinRM Service, The Following Error Was Reported:`n$($Error[0].Exception.Message)`n Please correct the issue and try again!`n"
			Break
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
		
		#Test Local Connectivity (Basic Auth)
		Write-Host "Testing Local Service Connectivity With Basic Auth..."
		try
		{
			$MasterCredential = Get-Credential -Message "Please Enter The Master Server Credentials"
			Test-WSMan -Authentication basic -Credential $MasterCredential -ErrorAction Stop | Out-Null
			Write-Host -Foreground Green "-Passed!`n"
		}
		catch
		{
			Write-Host "An Error While Testing The Local WinRM Service, The Following Error Was Reported:`n$($Error[0].Exception.Message)`n Please correct the issue and try again!`n"
			Break
		}
		
		#Test Remote Service Connectivity
		Write-Host "Testing Service Connectivity With Basic Auth..."
		try
		{
			$SlaveCredential = Get-Credential -Message "Please Enter The Slave Server Credentials"
			Test-WSMan -Computer $SlaveInternalIP -Authentication Basic -Credential $SlaveCredential -ErrorAction Stop | Out-Null
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
			$SlaveServerName = Invoke-Command -Computer $SlaveInternalIP -ScriptBlock {(Get-CimInstance Win32_ComputerSystem).Name}
			Write-Host "-Get Server GUID"
			$SlaveServerGUID = Invoke-Command -Computer $SlaveInternalIP -ScriptBlock {(Get-CimInstance Win32_ComputerSystemProduct).UUID }
			Write-Host "-Get Server OS Disk Info"
			$SlaveServerDiskInfo = Invoke-Command -Computer $SlaveInternalIP -ScriptBlock { Get-WMIObject Win32_LogicalDisk | Where-Object{$_.DriveType -eq 3} | Select-Object Name, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}} } 
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
		
		#Configure Remoting
		Write-Host "Configuring Remoting Slave Server Remoting Options..."
		try
		{
			Write-Host "-Service Basic Auth - True"
			Set-Item WSMan:\localhost\Service\Auth\Basic -Value $True
			
			Write-Host "-Service Allow Unencrypted Traffic - True"
			Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $True
			
			Write-Host "-Client Basic Auth - True"
			Set-Item WSMan:\localhost\Client\Auth\Basic -Value $True
			
			Write-Host "-Client Allow Unencrypted Traffic - True`n"
			Set-Item WSMan:\localhost\Client\AllowUnencrypted -Value $True
			
			Write-Host "-Client Trusted Host - $MasterServerInternalIP`n"
			Set-Item WSMan:\localhost\Client\TrustedHosts –Value $MasterServerInternalIP
		}
		catch
		{
			Write-Host "An Error While Configuring The WinRM Service, The Following Error Was Reported:`n$($Error[0].Exception.Message)`n Please correct the issue and try again!`n"
			Break
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
		
		#Test Local Connectivity (Basic Auth)
		Write-Host "Testing Local Service Connectivity With Basic Auth..."
		try
		{
			$MasterCredential = Get-Credential -Message "Please Enter The Master Server Credentials"
			Test-WSMan -Authentication basic -Credential $MasterCredential -ErrorAction Stop | Out-Null
			Write-Host -Foreground Green "-Passed!`n"
		}
		catch
		{
			Write-Host "An Error While Testing The Local WinRM Service With Basic Auth, The Following Error Was Reported:`n$($Error[0].Exception.Message)`n Please correct the issue and try again!`n"
			Break
		}
	}
	
	default {"Error Occurred! Please Restart Script!"; Break}
}
