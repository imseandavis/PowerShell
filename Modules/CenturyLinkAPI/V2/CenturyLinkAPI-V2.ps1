#CenturyLink API v2.0 Powershell Module
#Created By: Sean Davis

#Build Auth Token
$Auth = @{
 username = "" #CLC Username
 password = "" #CLC Password
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


#Get A Server In A Group
$AccountAlias = "" #4 Letter Code For Tenant
$GroupID = "" #Your Group ID, Get This From The URL When You Click On The Group In The Portal
$APIURL = "https://api.ctl.io/v2/groups/$AccountAlias/$GroupID"
$Content = Invoke-RestMethod -Method GET -Headers $Headers -URI $APIURL -ContentType "application/json" -SessionVariable "Session"
$Content


#Create A Group
$AccountAlias = "" #4 Letter Code For Tenant
$APIURL = "https://api.ctl.io/v2/groups/$AccountAlias"
$Content = @"
	{
		"name": "SEE API DOCS",
		"description", "SEE API DOCS",		
		"parentGroupId": "SEE API DOCS"
	}
"@
$Response = Invoke-RestMethod -Method POST -Headers $Headers -URI $APIURL -ContentType "application/json" -Body $Content -SessionVariable "Session"


#Get Network List
$AccountAlias = "YourAccountAlias" #4 Letter Code For Tenant
$Datacenter = "" #Your Datacenter Code
$APIURL = "https://api.ctl.io/v2-experimental/networks/$AccountAlias/$Datacenter"
$Networks = Invoke-RestMethod -Method GET -Headers $Headers -URI $APIURL -SessionVariable "Session"


#Add A Secondary NIC
$AccountAlias = "YourAccountAlias" #4 Letter Code For Tenant
$ServerID = "" #Server Name In Portal
$APIURL = "https://api.ctl.io/v2/servers/$AccountAlias/$ServerID/networks"
$Content = @"
	{
		"networkId": "SEE API DOCS",
	}
"@

try
{
	$Response = Invoke-RestMethod -Method POST -Headers $Headers -URI $APIURL -ContentType "application/json" -Body $Content -SessionVariable "Session"
	Write-Host "Secondary NIC Added Successfully!"
}


#Get-ServerStats
$StartDate = $($(Get-Date).AddDays(-12)).ToShortDateString()
$EndDate = $(Get-Date).ToShortDateString()
$AccountAlias = "" #4 Letter Code For Tenant
$ServerID = "ServerName" #Server Name In Portal
$APIURL = "https://api.ctl.io/v2/servers/$AccountAlias/$ServerID/statistics?type=hourly&sampleInterval=01:00:00&start=$StartDate&end=$EndDate"
$ServerStats = Invoke-RestMethod -Method GET -Headers $Headers -URI $APIURL -SessionVariable "Session"


#Get Template ID's
$AccountAlias = "" #4 Letter Code For Tenant
$Datacenter = "" #Your Datacenter Code
$APIURL = "https://api.ctl.io/v2/datacenters/$AccountAlias/$DataCenter/deploymentCapabilities"
$ServerStats = Invoke-RestMethod -Method GET -Headers $Headers -URI $APIURL -SessionVariable "Session"


#Provision A Server
$AccountAlias = "YourAccountAlias" #4 Letter Code For Tenant
$APIURL = "https://api.ctl.io/v2/servers/$AccountAlias"
$Content = @"
	{
		"name": "SEE API DOCS",		
		"groupId": "SEE API DOCS",
		"sourceServerID": "SEE API DOCS",
		"cpu": "SEE API DOCS",
		"memoryGB": "SEE API DOCS",
		"type": "SEE API DOCS"
	}
"@

$Response = Invoke-RestMethod -Method POST -Headers $Headers -URI $APIURL -ContentType "application/json" -Body $Content -SessionVariable "Session"
