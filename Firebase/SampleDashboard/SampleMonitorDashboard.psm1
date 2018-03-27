function New-MonitoredServer
{
	#Create A New Server Entry
	Invoke-RestMethod -Method PUT -URI "$Firebase_URL/Status/$Env:ComputerName.json" -Body "{`"name`": `"$Env:ComputerName`", `"Alarm`": `"Green`"}"
}

function Set-ServerStatus
{
	Param
	(
		[Parameter(Mandatory = $True)]
		[ValidateSet("Green", "Yellow", "Red")]
		[string]$Color,
		
		[string]$Firebase_URL = "https://poshfbdemo.firebaseio.com"
	)

	#Check To See If Server Records Exists
	If((Invoke-RestMethod -Method GET -URI "$Firebase_URL/Status/hi/Alarm.json").Current -eq $null)
	{
		#Create A New Server Entry
		Invoke-RestMethod -Method PUT -URI "$Firebase_URL/Status/$Env:ComputerName.json" -Body "{`"name`": `"$Env:ComputerName`", `"Alarm`": `"Green`"}"
	}
	Else
	{
		#Set Status Color For Server
		Invoke-RestMethod -Method PUT -URI "$Firebase_URL/Status/$Env:ComputerName/Alarm.json" -Body "{`"Current`": `"$Color`"}"
	}
}

function Add-ServiceMonitor
{
	Param
	(
		[string]$ServiceName,
		
		[string]$Firebase_URL = "https://poshfbdemo.firebaseio.com"
	)
	
	#Verify Service Exists On Server
	
	
	#Check If Service Record Exists
	
	#Set The Status For The Service 

}


function Add-WebsiteMonitor
{
	
}

function Add-PingMonitor
{

}