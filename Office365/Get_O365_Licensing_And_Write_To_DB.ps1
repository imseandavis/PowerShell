#Region Script Info
###################################################
#!CreatedBy: Sean Davis
#!ContactEmail: imseandavis@gmail.com
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
$PSEmailServer = "1.2.3.4" #Email Server - Internal Relay
$MaxRunTimeLogs = 5 #Max Amount Of Runtime Log Files to Retain Before Removing Oldest Log File
$PlatformEngineeringEmail = @("imseandavis@gmail.com")

#$SQLServer = "LOCALHOST\SCRIPTS"
#$Database = "Office365"
#$Table = "Licenses"
$MySQLAdminUserName = 'usernamegoeshere'
$MySQLAdminPassword = 'passwordgoeshere'
$MySQLDatabase = 'sqldbnamegoeshere'
$MySQLHost = 'sqlserverfqdngoeshere'
$MySQLTable = "Office365_Licenses"
$LogFile = "$($ScriptLocation)\Logs\$ScriptName.log"
###################################################
#endregion


#Region Functions
###################################################
Function Connect-Office365 {

<# 

 .Synopsis
  Connects to Office 365 Tenant

 .Description
  This script will establish a remote session with Office 365 and import required MSOL commandlets.
  
 .Parameter Environment
  Defines the Office 365 environment to connect to. Default is "Production". Acceptable values are "Production" and "Development" 
 
 .Inputs
  None
      You cannot pipe input to Connect-Office365.
  
 .Outputs
  None
      There is no value returned for Connect-Office365.
  
 .Example
      Connect-Office365 -Environment Production
	  Connects to production Office 365 environment, overrides default action limits, and sets them to 25 max.

 .Link
      
#>

	[cmdletBinding()]
	param(		
		[parameter(Position=0, HelpMessage="Environment Name")]
		[string]$Environment="Production"
	)
	
	#Set Connection Variable
	$IsConnected = $false
	
	#Check To See If There's Already An Active Session
	If ((Get-PSSession) -ne $null) {
		If((Get-PSSession | Select ConfigurationName -ExpandProperty ConfigurationName) -match "Microsoft.Exchange"){$IsConnected = $true}
	}
	
	#Connect To Office 365
	If($IsConnected -eq $false){
		
		Write-Host "-Processing -> `tConnecting To Office 365"
		
		If($(Get-PSSnapin | Where {$_.Name -like "Microsoft.Exchange.Management.PowerShell.E2010"} | Select Name -ExpandProperty Name) -contains "Microsoft.Exchange.Management.PowerShell.E2010"){
			Write-Warning "----> `tA Prefix of 'Office365' will been added to all Office 365 commandlets to prevent conflict with Exchange"
		}
		
		#Get Authorized Account To Connect (Must Run As The User Who Stored The Password)
		try{
			#$Password = (Get-ItemProperty -Path "HKLM:\Software\Scripts\Exchange").O365Token | ConvertTo-SecureString -EA SilentlyContinue
			#$UserName = (Get-ItemProperty -Path "HKLM:\Software\Scripts\Exchange").O365Name
			#$UserName = "office365usernamegoeshere"
			#$Password = "office365passwordgoeshere" | ConvertTo-SecureString -asPlainText -Force
			$UserName = "office365usernamegoeshere"
			$Password = "office365passwordgoeshere" | ConvertTo-SecureString -asPlainText -Force
			$O365Cred = New-Object System.Management.Automation.PSCredential $UserName, $Password
		}
		catch{
			Write-Warning "----> `tDetected Non Automaton Account! Requesting Global Admin Credentials."
			$O365Cred = Get-Credential -Credential "$Env:UserName"
		}
		#Connect To The Office 365 and Microsoft Online Services
		try
		{
			$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $O365Cred -Authentication Basic -AllowRedirection -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			$CloudSession =	Import-PSSession $O365Session -DisableNameChecking -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
			Write-Host "-Processing -> `tBinding MSOL Services"
			Import-Module MSOnline
			Connect-MsolService -Credential $O365Cred
			Write-Host "-Completed --> `tConnected To The Cloud!"
		}
		catch
		{
			Send-MailMessage -From "fromaddressgoeshere@domain.com" -To $PlatformEngineeringEmail -Subject "Office 365 License Report Dashboard Update Error!" -Body "Failed to Connect To Office 365, Please Run The Office 365 License Manager Again For Today!"
			break
		}
	}
	Else{
		Write-Host "-Completed --> `tAlready Connected To The Cloud!"
	}
}

Function Get-CloudLicenses {

<# 

 .Synopsis
  Queries Office 365 Tenant For All Licenses

 .Description
  This script query Office 365 for all license SKU's and gather total counts for reports.
  
 .Inputs
  None
      You cannot pipe input to Get-CloudLicenses.
  
 .Outputs
  None
      There is no value returned for Get-CloudLicenses.
  
 .Example
      Get-CloudLicenses
	  Gets cloud licenses for production Office 365 tenant.

 .Link
      
#>

	[cmdletBinding()]
	param(		
		[parameter(Position=0, HelpMessage="Environment Name")]
		[ValidateSet("PreProduction","Production")]
		[string]$global:Environment="Production"	
	)
	
	#Connect To Office 365
	Connect-Office365
		
	#Get Only Licenses From The Selected Environment
	Write-Host "-Processing -> `tQuerying Cloud Licenses For $Environment"
	$Licenses = Get-MSOLAccountSKU | Where {$_.ActiveUnits -ne 0}
		
	#Create The License Storage Object
	$CloudLicenseList = @()
			
	#Get Total Number Of License SKU's 
	ForEach($SKU in $Licenses){					
		
		#FOR DEBUG
		#Write-Host "Decoding SKU $($SKU.AccountSkuId.Split(":")[1])"
		
		Switch(($SKU.AccountSkuId.Split(":")[1])){
		
			"O365_BUSINESS_ESSENTIALS" {
				Write-Host "-Processing -> `tFound Business Essentials Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Business Essentials"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "BE"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"OFFICESUBSCRIPTION" {
				Write-Host "-Processing -> `tFound Business Essentials Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Office Pro Plus"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "OS"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"EXCHANGEDESKLESS" {
				Write-Host "-Processing -> `tFound Exchange Online - Kiosk Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Exchange Online - Kiosk"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "Kiosk"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"EXCHANGESTANDARD" {
				Write-Host "-Processing -> `tFound Exchange Online - Plan 1 Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Exchange Online - Plan 1"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "EOP1"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"EXCHANGEENTERPRISE" {
				Write-Host "-Processing -> `tFound Exchange Online - Plan 2 Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Exchange Online - Plan 2"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "EOP2"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"ENTERPRISEPACK" {
				Write-Host "-Processing -> `tFound Office 365 - Enterprise Plan 3 Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Office 365 - Enterprise Plan 3"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "E3"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"STANDARDPACK" {
				Write-Host "-Processing -> `tFound Office 365 - Enterprise Plan 1 Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Office 365 - Enterprise Plan 1"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "E1"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"MCOSTANDARD" {
				Write-Host "-Processing -> `tFound Office 365 - Lync Online Plan 2 Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Lync Online - Plan 2"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "LOP2"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"SHAREPOINTSTANDARD" {
				Write-Host "-Processing -> `tFound Office 365 - SharePoint Online Plan 1 Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "SharePoint Online - Plan 1"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "SOP1"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"PROJECTCLIENT" {
				Write-Host "-Processing -> `tFound Office 365 - Project Professional Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Project Professional"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "PP"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"VISIOCLIENT" {
				Write-Host "-Processing -> `tFound Office 365 - Visio Professional Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Visio Profesional"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "VP"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"PROJECTONLINE_PLAN_2" {
				Write-Host "-Processing -> `tFound Office 365 - Project Online Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Project Online"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "P0"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"POWER_BI_STANDARD" {
				Write-Host "-Processing -> `tFound Office 365 - Power BI Licensing For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Power BI Standard"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "PBIS"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"PROJECTESSENTIALS" {
				Write-Host "-Processing -> `tFound Office 365 - Project Lite For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Project Lite"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "PE"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"SHAREPOINTENTERPRISE_YAMMER" {
				Write-Host "-Processing -> `tFound Office 365 - SharePoint w/ Yammer (Add-On) For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "SharePoint w/ Yammer (Add-On)"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "SPY"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}
			
			"SHAREPOINTSTORAGE" {
				Write-Host "-Processing -> `tFound Office 365 - SharePoint Online Storage (Add-On) For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "SharePoint Online Storage (Add-On)"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "SPS"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}

			"POWERAPPS_INDIVIDUAL_USER" {
				Write-Host "-Processing -> `tFound Office 365 - Power Apps (Add-On) For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "Power Apps (Add-On)"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "PA"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			}

			default {
				Write-Host "-Processing -> `tFound Unknown Office 365 License For $Environment"
				$TenantSKU = New-Object System.Object
				$TenantSKU | Add-Member -type NoteProperty -Name Sku -Value $SKU.AccountSkuId
				$TenantSKU | Add-Member -type NoteProperty -Name Name -Value "UNKNOWN LICENSE"
				$TenantSKU | Add-Member -type NoteProperty -Name Flag -Value "UKL"
				$TenantSKU | Add-Member -type NoteProperty -Name Total -Value $SKU.ActiveUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Consumed -Value $SKU.ConsumedUnits
				$TenantSKU | Add-Member -type NoteProperty -Name Remaining -Value ($SKU.ActiveUnits - $SKU.ConsumedUnits)
			
			}
		}
		
		#Add The SKU To The SKU List
		$CloudLicenseList += $TenantSKU
	}
	
	#Close Any Open Sessions
	Get-PSSession | Remove-PSSession -ErrorAction SilentlyContinue
	
	Write-Host "-Processing -->  All Licenses Have Been Decoded!"
	return $CloudLicenseList	
}
###################################################
#endregion

#Start New Log Entry
Add-Content $LogFile ""

#Retrieve Licenses From The Office 365 Tenant Site
Write-Host "Getting Cloud Licenses..."
$Licenses = Get-CloudLicenses
  
#Connect To MySQL Metrics DB
try
{
	#Load MySQL DLL
	Write-Host "Loading MySQL Binaries..."
	[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
	
	Write-Host "Creating Connection Object..."
	$MySQLConnection = New-Object MySql.Data.MySqlClient.MySqlConnection
	
	Write-Host "Building Connection String..."
	$MySQLConnection.ConnectionString = "server=" + $MySQLHost + "; port=3306; uid=" + $MySQLAdminUserName + "; pwd=" + $MySQLAdminPassword + "; database=" + $MySQLDatabase
	
	Write-Host "Opening Connection To Database $Database On MySQL Server $SQLServer"
	$MySQLConnection.Open()
	
	Write-Host -Foreground Green "MySQL Database Connection Opened Successfully! `n"
	Add-Content $LogFile "$(Get-Date): MySQL DB Connection Opened!"
}
catch
{
	Write-Host "MySQL Database Connection Failed!"
	Add-Content $LogFile "$(Get-Date): MySQL DB Connection Failed!"
}
  
#Connect To SQL Metrics DB
#try
#{
#	Write-Host "Creating Connection Object..."
#	$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
#	
#	Write-Host "Building Connection String..."
#	$SQLConnection.ConnectionString = "Data Source=$SQLServer;Initial Catalog=$Database; Integrated Security=SSPI"
#	
#	Write-Host "Opening Connection To Database $Database On SQL Server $SQLServer"
#	$SQLConnection.Open()
#	
#	Write-Host -Foreground Green "Database Connection Opened Successfully! `n"
#	Add-Content $LogFile "$(Get-Date): DB Connection Opened!"
#}
#catch
#{
#	Write-Host "Database Connection Failed!"
#	Add-Content $LogFile "$(Get-Date): DB Connection Failed!"
#}

#If($SQLconnection.State -eq "Open")
If($MySQLconnection.State -eq "Open")
{
	#Loop Through All Licenses
	ForEach($License in $Licenses)
	{
		#Calculate Inactive License Churn For The Given License
		#Add License Churn Logic Here
		$Inactive = 0
		
		#Generate License Command
		#$LicenseCommand = $SQLConnection.CreateCommand()
		$LicenseCommand = $MySQLConnection.CreateCommand()
	
		#Populate License Command
		$LicenseCommand.CommandText = "INSERT INTO $MySQLTable (Date, License, Consumed, Remaining, Total, Inactive, UsagePercent) VALUES ('$(Get-Date -Format `"yyyy-MM-dd HH:mm:ss`")','$($License.Name)','$($License.Consumed)','$($License.Remaining)','$($License.Total)','$Inactive','$([System.Math]::Round($($($License.Consumed) / $($License.Total)), 2))')"
	
		#Execute License Command
		$Result = $LicenseCommand.ExecuteNonQuery()
		
		#Write Warning If No Updates Were Made
		If ($Result -eq 0)
		{
			Write-Warning "No Tables Were Updated!"
			Add-Content $LogFile "$(Get-Date): No Tables Were Updated!"
		}
		Else
		{		
			#Write Updates Committed To The Console And Logs
			Write-Host "The Following Data Was Written:`n`n Date: $(Get-Date) `n License: $($License.Name) `n Consumed: $($License.Consumed) `n Remaining: $($License.Remaining) `n Total: $($License.Total) `n Inactive: $Inactive`n UsagePercent: $([System.Math]::Round($($($License.Consumed) / $($License.Total)), 2)) `n"
			Add-Content $LogFile ""
		}
	}
	
	Add-Content $LogFile "$(Get-Date): Licensing Information Was Successfully Added To The Database!"
}

#Close DB Connection
Write-Host "Closing The Connection To Database $Database On SQL Server $SQLServer"
#$SQLConnection.Close()
$MySQLConnection.Close()
Write-Host -Foreground Green "Database Connection Closed Successfully! `n"
Add-Content $LogFile "$(Get-Date): DB Connection Closed!"

#Send Update Report To Platform Engineering Team
Write-Host "Sending Notification Email that Job Has Completed."
Send-MailMessage -From "adminemailgioesher@domain.com" -To $PlatformEngineeringEmail -Subject "Office 365 License Usage Update Complete!" -Body "Your report has successfully completed.`n`nPlease view the updated dashboard at YOURURLGOESHERE" -BodyAsHTML
