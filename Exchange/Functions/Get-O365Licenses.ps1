#Requires That You Install Azure Commandlets
#TODO: Add Functon To Auto Check

Function Get-O365Licenses {

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
	  
#>

	[cmdletBinding()]
	param(		
		[parameter(Position=0, HelpMessage="Environment Name")]
		[ValidateSet("PreProduction","Production")]
		[string]$Environment="Production"	
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
		
		#DEBUG
		Write-Debug "Decoding SKU $($SKU.AccountSkuId.Split(":")[1])"
		
		Switch(($SKU.AccountSkuId.Split(":")[1])){
		
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

			default {}
		}
		
		#Add The SKU To The SKU List
		$CloudLicenseList += $TenantSKU
	}
	
	#Close Any Open Sessions
	Get-PSSession | Remove-PSSession -ErrorAction SilentlyContinue
	
	Write-Host "-Completed -->  All Licenses Have Been Decoded!"
	return $CloudLicenseList	
}
