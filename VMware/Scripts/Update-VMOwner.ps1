Function Update-VMOwner {

<# 

 .Synopsis
  Updates The Owners On All Virtual Machines

 .Description
  This Script Will Parse Through All VM(s) On All Connected VI Servers And Set The "CreatedOn" and "CreatedBy" Attributes On A Virtual Machine. This Script Will Also Create The Attribute Values If Needed.
  
 .Inputs
  None
      You cannot pipe input to UpdateVMOwner.
  
 .Outputs
  None
      There is no value returned for UpdateVMOwner.

 .Example
      Update-VMOwner
	  Updates The Owner On All VM's Found On All Currently Connected VI Servers.

 .Link
      No Link Currently Available

#>

	#Define Variables
	$UnknownAttributeName = "Unknown" #Name For Attributes Not Found Or Could Not Be Determined
	$Message = "The VM's Listed Below Have Information That Could Not Be Retrieved, Please Have The VM Owner Manually Update The VM Annotations. `n`n" #VM Report Header Message
	$VMwareTeamEmail = "yourname@youremail.com"

	try
	{
		#Check To See If There's Already A "CreatedBy" Attribute On The VM, If Not Create It
		If (!(Get-CustomAttribute "CreatedBy" -ErrorAction SilentlyContinue)) {
			Write-Host "Creating 'CreatedBy' Attribute"
			New-CustomAttribute -Name "CreatedBy" -TargetType VirtualMachine
		}
		
		#Check To See If There's Already A "CreatedOn" Attribute On The VM, If Not Create It
		If (-NOT (Get-CustomAttribute "CreatedOn" -ErrorAction SilentlyContinue)) {
			Write-Host "Creating 'CreatedOn' Attribute"
			New-CustomAttribute -Name "CreatedOn" -TargetType VirtualMachine
		}
		
	}
	catch
	{
		Write-Warning "$($global:Error[0])"
		Break
	}

	#Get VM List
	Try {        
		$VMList = Get-VM
	}
	Catch {
		Write-Warning "$($global:Error[0])"
		Break
	}

	#Loop Through VM List And Populate The CreatedOn And CreatedBy Attributes
    ForEach ($VM in $VMList) {
        If (($VM.CustomFields['CreatedBy'] -eq $null) -OR ($VM.CustomFields['CreatedBy'] -eq "Unknown") -OR ($VM.CustomFields['CreatedOn'] -eq $null) -OR ($VM.CustomFields['CreatedOn'] -eq "Unknown")) {
            Write-Host "$($VM.Name) - Missing or Unknown Information Found, Attempting To Update."
            Try {

				#Build Historical Event Log For Current VM
				$Events = $VM | Get-VIEvent -MaxSamples 500000 -Types Info | Where {
                    $_.GetType().Name -eq "VmBeingDeployedEvent" `
					-OR $_.Gettype().Name -eq "VmCreatedEvent" `
					-OR $_.Gettype().Name -eq "VmRegisteredEvent" `
                    -OR $_.Gettype().Name -eq "VmClonedEvent"
                }
				
				#If There Are No Events to Be Found Write "Unknown" For The Attributes
                If (($Events | Measure-Object).Count -eq 0) {
                    $CreatedBy = $UnknownAttributeName
                    $CreatedOn = $UnknownAttributeName
                }
                Else{
                    
					#Set The VM CreatedBy Attribute
					If ($Events.UserName -eq $null) {
                        $CreatedBy = $UnknownAttributeName
                    }
                    Else {
						$CreatedBy = $Events.UserName
                    }
					
                    #Set The VM CreatedOn Attribute
					$CreatedOn = $Events.CreatedTime
                }
				
				#Update VM Attributes
				$VM | Set-Annotation -CustomAttribute "CreatedBy" -Value $CreatedBy | Out-Null
				$VM | Set-Annotation -CustomAttribute "CreatedOn" -Value $CreatedOn | Out-Null
				If (($VM.CustomFields['CreatedBy'] -eq $null) -OR ($VM.CustomFields['CreatedBy'] -eq "Unknown") -OR ($VM.CustomFields['CreatedOn'] -eq $null) -OR ($VM.CustomFields['CreatedOn'] -eq "Unknown")) {
					Write-Warning " -The Update Was Unable To Determine The Values For CreatedOn And/Or CreatedBy. Please Have The VM Owner Manually Update This Information."
					$Message += "VM Name: $($VM.Name) `n"
					$Message += "VM Created By Value: $($VM.CustomFields['CreatedBy']) `n"
					$Message += "VM CreatedOn Value: $($VM.CustomFields['CreatedBy']) `n`n"
				}
				Else{
					Write-Host " -Information Retrieved For CreatedBy, New Value: $CreatedBy"
					Write-Host " -Information Retrieved For CreatedOn, New Value: $CreatedOn"
                }
            }
            Catch {
                Write-Warning "$($global:Error[0])"
            }
        }
    }
	
	#Send Update Report To Virtualization Team
	Send-MailMessage -SmtpServer $SMTPserver -To $VMwareTeamEmail -From "SCRIPTNAME@$CurrentServer" -Subject "VM Annotation Report" -Body $Message 
}