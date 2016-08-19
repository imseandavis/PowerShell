#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

function Get-CL_Accounts
{
	#Go Grab All The Users
	$RequestURL = 'https://api.ctl.io/REST/Account/GetAccounts/JSON'
	$Content = Invoke-WebRequest -URI $RequestURL -Method POST -ContentType application/json -WebSession $session
	$Users = $Content.Content

	#Show Me The User Objects
	($Users | ConvertFrom-JSON).Accounts
}

function Get-CL_Networks
{
	#Go Grab All The Users
	$RequestURL = 'https://api.ctl.io/REST/Network/GetNetworks/JSON'
	$Content = Invoke-WebRequest -URI $RequestURL -Method POST -ContentType application/json -WebSession $session
	$Networks = $Content.Content

	#Show Me The User Objects
	($Networks | ConvertFrom-JSON).Networks
}

function Get-CL_ParentCompany
{
	param ($Account)
	
	#Go Grab All The Users
	$RequestURL = 'https://api.ctl.io/REST/Account/GetAccounts/JSON'
	$Content = Invoke-WebRequest -URI $RequestURL -Method POST -ContentType application/json -WebSession $session
	$Users = $Content.Content
	
	#Show Me The User Objects
	return $(($Users | ConvertFrom-JSON).Accounts | where {$_.AccountAlias -eq $Account }).ParentAlias
}