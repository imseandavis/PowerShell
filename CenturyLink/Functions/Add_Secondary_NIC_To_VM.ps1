<#
	.SYNOPSIS
	Add A Secondary NIC To A CLC Server
	.DESCRIPTION
	Add A Secondary NIC To A CLC Server
	.PARAMETER Account Alias
	The Account Alias ID For The Tenant
	#>
	  
[CmdletBinding()]
param
(
	[Parameter(Mandatory=$True, Position=1)]
	[string]$AccountAlias,

    [Parameter(Mandatory=$True, Position=2)]
	[string]$ServerName,
	
	[Parameter(Mandatory=$True, Position=2)]
	[string]$NetworkID,
)
	

#Start The StopWatch
$StopWatch = [Diagnostics.Stopwatch]::StartNew()

#Build Auth Token
$Auth = @{
 username = "USERNAME"
 password = "PASSWORD"
}
$AuthToken = $Auth | ConvertTo-JSON

#Init Headers
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

#Login And Receive Token
$LogonUrl = "https://api.ctl.io/v2/authentication/login"
$LogonResponse = Invoke-RestMethod -Method Post -Headers $Headers -URI $LogonUrl -Body $AuthToken -ContentType "application/json" -SessionVariable "Session"

#Format The Bearer Token
$Bearer = $LogonResponse.bearerToken
$BearerToken = " Bearer " + $Bearer

#Add The Token to The Header To Be Used For All Future Requests
$Headers.Add("Authorization",$BearerToken)

#Make The Session Global For The Persistence Of The User Session Or Two Weeks, Whichever Comes First
$Session = $global:Session

#Add A Secondary NIC
#Hardcoded To Add A NIC To The .75 Network
$APIURL = "https://api.ctl.io/v2/servers/$AccountAlias/$ServerName/networks"
$Content = @"
	{
		"networkId": "$NetworkID"
	}
"@

try
{
	Write-Host "Adding A Secondary Network To $ServerName"
	$Response = Invoke-RestMethod -Method POST -Headers $Headers -URI $APIURL -ContentType "application/json" -Body $Content -SessionVariable "Session"
	Write-Host "Secondary NIC Added Successfully!"
}

$StopWatch.Stop()
Write-Host "`nSeocndary NIC Add Completed! Estimated Time Was: $([math]::round($(($StopWatch.Elapsed).Seconds), 2)) seconds(s)"
