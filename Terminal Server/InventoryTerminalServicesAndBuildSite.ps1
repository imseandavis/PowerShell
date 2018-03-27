#Get Terminal Server Connection Metrics And Create a IIS Website To View Them
#By: Sean Davis 6/29/2012 

Function Get-ServerInfo
{

	Param(
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)] [string[]]$Server
	)
	
	Begin
	{
		#Generate A New Variable Based On The Server Name 
		New-Variable -Name "$Server" -Scope Global -Value @() 
	}
 
	Process
	{ 
		#Get Basic Server Info 
		$TempVar = "" | Select ServerName, PrimaryIP, CPUPercent, RAMPercent, IsTerminalServer, IsSQLServer, IsWebServer, ActiveSessionCount, InactiveSessionCount, ConsoleSessionCount
		$TempVar.ServerName = $Server 
		$TempVar.PrimaryIP = GWMI -ComputerName $Server Win32_NetworkAdapterConfiguration | Where {$_.IPEnabled -eq	$True -and $_.DHCPEnabled -eq $False} | Select IPAddress -ExpandProperty IPAddress
		$TempVar.CPUPercent = GWMI Win32_Processor -Computer $Server | Measure-Object -property LoadPercentage -Average | Select Average -ExpandProperty Average 
		$TempVar.RAMPercent = GWMI Win32_0peratingSystem -Computer $Server | Select TotalVisibleMemorySize, FreePhysicalMemory | Add-Member -MemberType ScriptProperty -Name UsedPercent -Value {[Math]::Round(100 - ($this.FreePhysicalMemory / $this. TotalVisibleMemorySize) * 100)} -PassThru | Select UsedPercent -ExpandProperty UsedPercent
		$TempVar.IsTerminalServer = GWMI Win32_ServerFeature -Computer $Server | Se1ect Name | Where {$_. Name -eq "Remote Desktop Session Host"} | Add-Member -MemberType ScriptProperty -Name IsTerminalServer -Value {IF ($this.Name -eq "Remote Desktop Session Host") {"Yes"} ELSE IF ($this.Name -eq " ") {"No"} } -PassThru | Select	IsTerminalServer -ExpandProperty IsTerminalServer
		$TempVar.IsSQLServer = '' 
		$TempVar.IsWebServer = ''
	 

		$Report = @ () 
		$Sessions = quser.exe /server:$Server 
		If ($Sessions -eq $null) { Write-Host "No Open Sessions On Computer"; Break}
		Else
		{
			1..($Sessions.count -l) | %	{
				$Temp = "" | Select USERNAME, SESSIONNAME, STATE, LAST LOGON TIME #Removed ID - INFO NOT NEEDED
				$Temp.USERNAME = $Sessions[$_].Substring(1,22).Trim() #DONE
				$Temp.SESSIONNAME = $Sessions[$_].Substring(23,13).Trim() #DONE
				#$Temp.ID = $Sessions[$_].Substring(36,lO).Trim() #INFO NOT NEEDED
				$Temp.STATE = $Sessions[$_].Substring (46,6).Trim() #DONE 
				$Temp.LAST_LOGON_TTME = $Sessions[$_].Substring(65).Trim() #DONE 
				$Report += $Temp 
			}
		}
		
		$TempVar.ActiveSessionCount = ($Report | Where {$_.STATE -eq "Active"} | Measure-Object).Count 
		$TempVar.InactiveSessionCount = ($Report | Where {$_.STATE -eq "Disc"} | Measure-Object).Count 
		$TempVar.ConsoleSessionCount = ($Report | Where {$_.SESSIONNAME -eq "Console"} | Measure-Object).Count 
		
		$TempVar 
	}
}

	
Function Get-Sessions
{
 
	Param(
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)] [string[]]$Computer
	)	

	Begin {}
	
	Process
	{
		#Parse 'quser' and store in Custom Object - $Sessions 
		$Report = @() 
		$Sessions = quser.exe /server:$Computer 
		If ($Sessions -eq $null) { Write-Host "No Open Sessions On Computer"; Break}
		Else
		{
			1..($Sessions.count -l) | %	{
				$Temp = "" | Select USERNAME, SESSIONNAME, STATE, LAST LOGON TIME #Removed ID - INFO NOT NEEDED
				$Temp.USERNAME = $Sessions[$_].Substring(1,22).Trim() #DONE
				$Temp.SESSIONNAME = $Sessions[$_].Substring(23,13).Trim() #DONE
				#$Temp.ID = $Sessions[$_].Substring(36,lO).Trim() #INFO NOT NEEDED
				$Temp.STATE = $Sessions[$_].Substring (46,6).Trim() #DONE 
				$Temp.LAST_LOGON_TTME = $Sessions[$_].Substring(65).Trim() #DONE 
				$Report += $Temp 
			}
		}
	}
	
	End
	{
		New-Variable -Name "Active_$Computer" -Scope Global -Value ($Report | Where {$_.State -eq "Active"} | Measure-Object).Count
		New-Variable -Name "Inactive_$Computer" -Scope Global -Value ($Report | Where {$_.State -eq "Disc"} | Measure-Object).Count
		New-Variable -Name "Sessions_$Computer" -Scope Global -Value $Report
	}
}	


#Start A Session Transcript 
Start-Transcript C:\Scripts\LastScriptRun.txt | Out-Null

#Cleanup Any Old Print Server Reports From The Webroot 
Write-Host "Cleanup Old Server Reports..."
Remove-Item C:\inetpub\wwwroot\*.csv | Out-Null

#Cleanup Any Old User Lists From The Webroot 
Write-Host "Cleanup Old User Lists Reports ..." 
Remove-Item C:\inetpub\wwwroot\SERVER*.html | Out-Null
Remove-Item C:\inetpub\wwwroot\UserList.txt | Out-Null 

#Get The Creds Required To Do The WMI Queries 
Write-Host Setting Credentials .... 
$User = "yourusernamehere"
$Password = Get-Content 'C:\Scripts\Automaton.inf' | ConvertTo-SecureString
$Creds = New-Object System.Management.Automation.PsCredential ($User,$Password)

#Get List Of Servers To Monitor 
$ServerList = GC C:\Scripts\Servers.txt 

#Run The Print Server Report And Post 
Write-Host "Writing Print Server Report..."
$Date = Get-Date 
$File = "C:\inetpub\wwwroot\index.html"
$PrintName = "PrinterList_$99get-date0.toString9'MM-dd-yyyy'))" + ".csv"

#Run The Report And Generate The File
GWMI Win32_Printer -Computer PRINTSERVER.DOMAIN -Credential $Creds | Select ShareName, PortName, Location, Comment | Export-CSV "C:\inetpub\wwwroot\$PrintName"

#Update The Timestamp And Link On The Website 
(Get-Content $File) | Foreach-Object {$_ -replace "(<A id=PrinterInfo).*", "<A id='PrinterInfo' href='$PrintName'>SERVER - Last Updated: $Date</A>"} | Set-Content $File

#Add Servers To Do The WMI Queries For The TS Connections Here 
Write-Host "Querving Servers For Connections..." 
#Get Server Statistics 
ForEach ($Server in $ServerList) 
	Get-Sessions $Server 
}

#Write The Changes To The HTML File Required To Update The Website
Write-Host " -Updating Terminal Server User Lists..."
$TS_STATS_HTMLFile = 'C:\intetpub\wwwroot\TS_Stats.html'

#Write Update Timestamps on GP TS_Stats Page
(Get-Content $TS_STATS_HTMLFile) | Foreach-Object {$_ -replace "<div id=TimeStamp).*" , "<div id=TimeStamp style=margin-left:20px>$Date</div>"} | Set-Content $TS_STATS_HTMLFile

#Write The Terminal Server Users Lists 
ForEach ($Server in $ServerList) 
{
	#Get The Variables Needed 
	$ServerSession = Get-Variable "Sessions_$Server" | Select * -ExpandProperty Value | FT USERNAME, SESSIONNAME, STATE, LAST LOGON TIME
	$Sessionlnfo = $ServerSession | Out-String 
	$CPUPercent = GWMI Win32_Processor -Computer $Server | Measure-Object -property LoadPercentage -Average | Select Average -ExpandProperty Average
	$RAM = GWMI Win32_OperatingSystem -Computer $Server | Select Total VisibleMemorySize, FreePhysicalMemory
	[int] $RAMFreePercent = $($RAM.FreePhysicalMemory / $RAM.TotalVisibleMemorySize * l00) 
	$RAMPercent = lOO - $RAMFreePercent 

	#Generate The Webpage
	Add-Content "C:\inetpub\wwwroot\$Server.html" '<!DOCTYPE html>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" '<head>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '	<meta http-equiv="Pragma" content="no-cache">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <meta http-equiv="Expires" content="-1">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <meta http-equiv="Refresh" content="30">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <link href="css/jquery-ui.css" rel="stylesheet" type="text/css"'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <script src="http://ajax.googleapis.com/ajax/libs/jquery-ui/1.8/jquery-ui.min.js"></script>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <script>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 	$(document).ready(function() {'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '			$("#cpu_usage").progressbar({ value: $CPUPercent });'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '		});'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' </script>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <script>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 	$(document).ready(function() {'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '			$("#ram_usage").progressbar({ value: $RAMPercent });'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '		});'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' </script>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" '</head>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" '<body style="scrollbar-base-color: #44444; scrollbar-face-color: #777777; scrollbar-arrow-color: #bbbbbb">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <table align="center">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 	<tr>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 		<td style="width: 200px; padding-lef: 50px; padding-right: 50px">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 			<div style="color: white">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" "					CPU Utilization: $CPUPercent % "
	Add-Content "C:\inetpub\wwwroot\$Server.html" '					<div id="cpu_usage" style="height: 5px;"></div>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '				</div>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 		</td>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 		<td style="width: 200px; padding-lef: 50px; padding-right: 50px">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 			<div style="color: white">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" "					RAM Utilization: $RAMPercent % "
	Add-Content "C:\inetpub\wwwroot\$Server.html" '					<div id="ram_usage" style="height: 5px;"></div>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '				</div>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 		</td>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' 	</tr>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' </table>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' </br>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' <pre style="color: white; margin-left: 25px;">'
	Add-Content "C:\inetpub\wwwroot\$Server.html" " 	$Session Info"
	Add-Content "C:\inetpub\wwwroot\$Server.html" ' </pre>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" ''
	Add-Content "C:\inetpub\wwwroot\$Server.html" '</body>'
	Add-Content "C:\inetpub\wwwroot\$Server.html" '</html>'
}
	
#Update Terminal Server Connection Chart
Write-Host " -Updating Terminal Server Statistics..."
$TS_JSON_File = 'C:\inetpub\wwwroot\TS_Barchart.js'

#Update Server Connection Values - Update This With For Loop
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0025-JSON)", "  'values': [$Active_SERVER0025, $Inactive_SERVER0025]  //SERVER0025-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0026-JSON)", "  'values': [$Active_SERVER0026, $Inactive_SERVER0026]  //SERVER0026-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0041-JSON)", "  'values': [$Active_SERVER0041, $Inactive_SERVER0041]  //SERVER0025-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0042-JSON)", "  'values': [$Active_SERVER0042, $Inactive_SERVER0042]  //SERVER0025-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0043-JSON)", "  'values': [$Active_SERVER0043, $Inactive_SERVER0043]  //SERVER0043-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0044-JSON)", "  'values': [$Active_SERVER0044, $Inactive_SERVER0044]  //SERVER0044-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0045-JSON)", "  'values': [$Active_SERVER0045, $Inactive_SERVER0045]  //SERVER0045-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0046-JSON)", "  'values': [$Active_SERVER0046, $Inactive_SERVER0046]  //SERVER0046-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0047-JSON)", "  'values': [$Active_SERVER0047, $Inactive_SERVER0047]  //SERVER0047-JSON "} | Set-Content $TS_JSON_File
(Get-Content $TS_JSON_File) | Foreach-Object {$_ -replace ".*(SERVER0048-JSON)", "  'values': [$Active_SERVER0048, $Inactive_SERVER0048]  //SERVER0048-JSON "} | Set-Content $TS_JSON_File
 
#Write The Master Users List 
$Master_User_File = 'C:\inetpub\wwwroot\UserList.txt' 
 
#Write The Update To The Index Page 
(Get-Content $File) | Foreach-Object {$_ -replace "<A id=UserInfo).*", "<A id=UserInfo href='UserList.txt'>Terminal Server Master User List - Last Updated: $Date</A>"} | Set-Content $File 

#Write The Master Users List
Write-Host "Writing The Master Users List..."
Add-Content $Master User File "Master Users List: Last Updated $Date" 
Add-Content $Master_User_File " " 
ForEach ($Server in $ServerList) 
{ 
	#Get The Variables Needed 
	$ServerSessionlnfo = Get-Variable "Sessions_$Server" | Select * -ExpandProperty Value | FT USERNAME, SESSIONNAME, STATE, LAST_LOGON_TIME
	$Info = $ServerSession | Out-String

	Add-Content $Master_User_File "$Server"
	Add-Content $Master_User_File $Info | Select * -ExpandProperty Value | FT USERNAME, SESSIONNAME, STATE, LAST LOGON TIME
}

#Write Out The Stats To File So They Can Be Manually Verified Against The Site
Write-Host " "
Write-Host ":::DEBUG:::"
Write-Host " "
Write-Host "Write Out Stats So They Can Be Manually Verified Against The Site..."
Write-Host "SERVER0025 has Active: $Active SERVER0025 and Disconnected: $Inactive_SERVER0025 connections." 
Write-Host "SERVER0026 has Active: $Active SERVER0026 and Disconnected: $Inactive_SERVER0026 connections." 
Write-Host "SERVER0041 has Active: $Active SERVER0041 and Disconnected: $lnactive SERVER0041 connections."
Write-Host "SERVER0042 has Active: $Active SERVER0042 and Disconnected: $lnactive SERVER0042 connections."
Write-Host "SERVER0043 has Active: $Active SERVER0043 and Disconnected: $lnactive SERVER0043 connections."
Write-Host "SERVER0044 has Active: $Active SERVER0044 and Disconnected: $lnactive SERVER0044 connections."
Write-Host "SERVER0045 has Active: $Active SERVER0045 and Disconnected: $lnactive SERVER0045 connections."
Write-Host "SERVER0046 has Active: $Active SERVER0046 and Disconnected: $lnactive SERVER0046 connections."
Write-Host "SERVER0047 has Active: $Active SERVER0047 and Disconnected: $lnactive SERVER0047 connections."
Write-Host "SERVER0048 has Active: $Active SERVER0048 and Disconnected: $lnactive SERVER0048 connections."
Write-Host " "
Write-Host "Write Out The User List Tables So They Can Be Manually Verified Against The Site..."
Write-Host "SERVER0025" 
Write-Host "$Sessions_SERVER025 | Out-String"
Write-Host "SERVER0026" 
Write-Host "$Sessions_SERVER026 | Out-String"
Write-Host "SERVER0041" 
Write-Host "$Sessions_SERVER041 | Out-String"
Write-Host "SERVER0042" 
Write-Host "$Sessions_SERVER042 | Out-String"
Write-Host "SERVER0043" 
Write-Host "$Sessions_SERVER043 | Out-String"
Write-Host "SERVER0044" 
Write-Host "$Sessions_SERVER044 | Out-String"
Write-Host "SERVER0045" 
Write-Host "$Sessions_SERVER045 | Out-String"
Write-Host "SERVER0046" 
Write-Host "$Sessions_SERVER046 | Out-String"
Write-Host "SERVER0047" 
Write-Host "$Sessions_SERVER047 | Out-String"
Write-Host "SERVER0048" 
Write-Host "$Sessions_SERVER048 | Out-String"

#Stop The Session Transcript 
Stop-Transcript | Out-Null 
