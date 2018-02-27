Function Clear-OrphanHomeServerMailboxes {

<# 

 .Synopsis
  Find Mailboxes Orphaned To Exchange Server Default Accounts.

 .Description
  This script was created to clean up the accounts that still have links to a particular exchange server that is attempting to be decommissioned. Please see the links to see the related Microsoft knowledgebase article.

 .Parameter HomeServerName
  Defines the home server name you are trying to decommission.
 
 .Inputs
  None
      You can pipe any string input to Clear-OrphanHomeServerMailboxes.
  
 .Outputs
  None
      There is no value returned for Clear-OrphanHomeServerMailboxes.
  
 .Example
      Clear-OrphanHomeServerMailboxes -HomeServerName Server123
	  Runs the script, and finds all mailboxes with an msExchHomeServerName attribute of Server123 and clears the attribute value.

 .Link
      DO NOT USE THIS COMMANDLET IF YOU ARE HAVING ANY ISSUES NOT RELATED TO THE BELOW KB ARTICLE!
	  
	  This resolves related MS KB Article: http://support.microsoft.com/kb/279202 or http://support.microsoft.com/kb/924170
	  
#>

	[CmdletBinding()]
	param(
	[parameter(Mandatory=$true, HelpMessage="Home Server Name To Search")]
	[ValidateNotNullOrEmpty()]
	$HomeServerName)

	#WARNING
	Write-Warning "Only Use This If you Are Decommissioning Exchange Servers!!!"
	
	$Answer = Read-Host "Do You Want To Continue? (Y/N)"
	If(($Answer -match "yes") -or ($Answer -match "Yes") -or ($Answer -match "Y") -or ($Answer -match "y")){
	
		#Get Orphan Home Server Mailboxes
		$OrphanList = (Get-Mailbox -WarningAction SilentlyContinue | Where-Object {$_.ServerName -like $HomeServerName})
	
		#For Loop Through Variable And Kill Orphans
		If($OrphanList -ne $null){
			ForEach($Orphan in $OrphanList){
		
				#Prompt User To Remove The Attributes From The Account
				$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
				$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
				$Choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No)
				$Caption = "Warning! Are You Sure You Want To Remove The Home Server $HomeServerName From: "
				$Message = $Orphan.Name
				$Result = $Host.UI.PromptForChoice($Caption,$Message,$Choices,0)
		
				if($Result -eq 0) {
					Write-Host "Removing Home Server $HomeServerName From: " $Orphan.Name
					Get-ADUser $Orphan.Name | Set-ADUser -Clear msExchHomeServerName
				}
		
				if($Result -eq 1) {
					Write-Host "Ignoring: $Orphan"
				}
			}
		}
		Else{
			Write-Host "No Orphaned Home Server Mailboxes Found!"
		}
	}
	Else{
		Break
	}
}
