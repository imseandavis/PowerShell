#Region Script Info
###################################################
#!CreatedBy: Sean Davis
#!ContactEmail:
#!Version: 1.0
#!DocumentationURL: N/A
#!Description: This script gathers information about Office 365 Licensing and writes it to a SQL database for Datazen to parse for Office 365 Licensing Dashboard.
###################################################
#endregion


#Region Static Variables
###################################################
$scriptPath = (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
$ScriptName = $((($MyInvocation.MyCommand.name) -split '.ps1')[0]) #Detects And Generates The Script Name
$Invocation = (Get-Variable MyInvocation).Value #Get The Invocation Path
$ScriptLocation = Split-Path $Invocation.MyCommand.Path #Get The Script Location
$MaxRunTimeLogs = 5 #Max Amount Of Runtime Log Files to Retain Before Removing Oldest Log File
$SQLServer = "YOURSQLSERVERHERE"
$Database = "YOURDBHERE"
$Table = "YOURTABLEHERE"
$LogFile = "$($ScriptLocation)\Logs\$ScriptName.log"
###################################################
#endregion


#Start New Log Entry
Add-Content $LogFile ""

#Import MSOnline Module - Bug Caused It Not To Connect Sometimes, So This Is Here For Redundancy, Blame MS... 12/11/2014
Import-Module MSOnline

#Retrieve Licenses From The Office 365 Tenant Site
$Licenses = Get-CloudLicenses
  
#Connect To SQL Metrics DB
try
{
	Write-Host "Creating Connection Object..."
	$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
	
	Write-Host "Building Connection String..."
	$SQLConnection.ConnectionString = "Data Source=$SQLServer;Initial Catalog=$Database; Integrated Security=SSPI"
	
	Write-Host "Opening Connection To Database $Database On SQL Server $SQLServer"
	$SQLConnection.Open()
	
	Write-Host -Foreground Green "Database Connection Opened Successfully!"
	Add-Content $LogFile "$(Get-Date): DB Connection Opened!"
}
catch
{
	Write-Host "Database Connection Failed!"
	Add-Content $LogFile "$(Get-Date): DB Connection Failed!"
}

If($SQLconnection.State -eq "Open")
{
	#Loop Through All Licenses
	ForEach($License in $Licenses)
	{
		#Calculate Inactive License Churn For The Given License
		#Add License Churn Logic Here
		$Inactive = 0
		
		#Generate License Command
		$LicenseCommand = $SQLConnection.CreateCommand()
	
		#Populate License Command
		$LicenseCommand.CommandText = "INSERT INTO $Table (Date, License, Consumed, Remaining, Total, Inactive, UsagePercent) VALUES ('$(Get-Date)','$($License | Select Name -ExpandProperty Name)','$($License | Select Consumed -ExpandProperty Consumed)','$($License | Select Remaining -ExpandProperty Remaining)','$($License | Select Total -ExpandProperty Total)','$Inactive','$([System.Math]::Round($($($License | Select Consumed -ExpandProperty Consumed) / $($License | Select Total -ExpandProperty Total)), 2))')"
	
		#Execute License Command
		$Result = $LicenseCommand.ExecuteNonQuery()
		
		#Write Warning If No Updates Were Made
		If ($Result -eq 0)
		{
			Write-Warning "No Tables Were Updated!"
			Add-Content $LogFile "$(Get-Date): No Tables Were Updated!"
		}
		
		#Write Updates Committed To The Console And Logs
		Write-Host "The Following Data Was Written:`n`nDate: $(Get-Date) `n License: $($License | Select Name -ExpandProperty Name) `n  Consumed: $($License | Select Consumed -ExpandProperty Consumed) `n Remaining: $($License | Select Remaining -ExpandProperty Remaining) `n Total: $($License | Select Total -ExpandProperty Total) `n Inactive: $Inactive`n UsagePercent: $([System.Math]::Round($($($License | Select Consumed -ExpandProperty Consumed) / $($License | Select Total -ExpandProperty Total)), 2)) `n"
		Add-Content $LogFile ""
	}
	
	Add-Content $LogFile "$(Get-Date): Licensing Information Was Successfully Added To The Database!"
}

#Close DB Connection
Write-Host "Closing The Connection To Database $Database On SQL Server $SQLServer"
$SQLConnection.Close()
Add-Content $LogFile "$(Get-Date): DB Connection Closed!"
