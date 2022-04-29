#Region Script Info
###################################################
#!CreatedBy: Sean Davis
#!ContactEmail: sean.davis@manheim.com
#!Version: 1.0
#!DocumentationURL: N/A
#!Description: This script gathers information about Office 365 Licensing and writes it to a SQL database for Datazen to parse for Office 365 Licensing Dashboard.
###################################################
#endregion


#Region Static Variables
###################################################
$ScriptPath = (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent) # Get The Scripts Path
$ScriptName = $((($MyInvocation.MyCommand.Name) -split '.ps1')[0]) #Get Current Script Name
$Invocation = (Get-Variable MyInvocation).Value #Get The Invocation Path
$ScriptLocation = Split-Path $Invocation.MyCommand.Path #Get The Script Location
Set-Location $ScriptLocation #Set The Location To Local Path For Script
$global:Domain = (Get-WmiObject Win32_ComputerSystem).Domain #Get Server Domain
$global:CurrentServer = "$((Get-WmiObject Win32_ComputerSystem).DNSHostName).$Domain" #Get Current Server Name
$LogFilePath = "$($ScriptLocation)\Logs\" #Define Default Log File Path
$LogFile = "$($ScriptLocation)\Logs\$(Get-Date -f 'MM-dd-yy_HHmmss') - $ScriptName.log" #Generate The Dynamic Log File Name For This Run
$MaxTranscriptLogs = 10 #Max Amount Of Runtime Log Files to Retain Before Removing Oldest Log File (Used For Log Maintenance When Using Start Transcript)
###################################################
#endregion


#Region Functions
###################################################

###################################################
#endregion


#Region Main Code
###################################################
#Start The Script Logging
Start-Transcript $LogFile

#Transcript Log Maintenance
If (((Get-ChildItem "$ScriptLocation\Logs").Count) -ge $MaxTranscriptLogs){
	Get-ChildItem "$ScriptLocation\Logs" | Where {$_.Attributes -ne "Directory"} | Sort CreationTime -Descending | Select -Skip $MaxTranscriptLogs | Remove-Item -Force
}

### YOUR CODE GOES HERE ###

#Stop Logging
Stop-Transcript
###################################################
#endregion