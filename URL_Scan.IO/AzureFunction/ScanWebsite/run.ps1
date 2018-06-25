# POST method: $req
$requestBody = Get-Content $req -Raw | ConvertFrom-Json
$URL = $requestBody.URL

# GET method: each querystring parameter is its own variable
if ($req_query_URL) 
{
    $URL = $req_query_URL 
} 

#Define Variables
$APIKey = "YOURKEYGOESHERE"
$Body = "{`"url`": `"$URL`", `"public`": `"off`"}"

#Build Header
$Headers = @{}
$Headers.Add("API-Key","$APIKey")

#Hack To Set TLS To v1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Make Request To Have Site Scanned
try
{
    Write-Output "Scanning $URL"
    $SiteRequest = Invoke-WebRequest -URI "https://urlscan.io/api/v1/scan/" -Method POST -ContentType 'application/json' -Header $Headers -Body $Body -UseBasicParsing
}
catch
{
    Write-Output "Failed To Request Scan."
}
#Check To See That We Got A 200 Status Code
If ($SiteRequest.StatusCode -eq 200)
{
	#Retrieve Scan Results UUID For Website
	$ScanID = ($SiteRequest.Content | ConvertFrom-JSON).uuid
	
	#Make Request For Scan Results And Wait If It's Not Done
	$SiteDone = $false
    Do
    {
        Sleep 5
        Write-Output "Retrieving Scan Results For ID: $ScanID"
        try
        {
            $SiteScanResults = Invoke-WebRequest -URI "https://urlscan.io/api/v1/result/$ScanID/" -Method GET -ContentType 'application/json' -UseBasicParsing
            $SiteDone = $true
            Write-Output "Scan Completed!"
        }
        catch
        {
            Write-Output "Scan Not Completed, Sleeping For 10 More Seconds..."
        }
    }
    While($SiteDone -eq $false)


	#Check To See If We Got A 200 Status Code
	If ($SiteScanResults.StatusCode -eq 200)
	{
		$ResultsJSON = $($SiteScanResults.Content | ConvertFrom-JSON)
		
		#Assign Data Points To Variables
		$WebsiteRequests = $ResultsJSON.data.requests.request #This tells us about the requests being made by the page scanned (This is informational)
		$ConsoleMessages = $ResultsJSON.data.console.message #This tells us with is being logged in the console when this page is loaded (This can indicate issues with the code on the site) (Use generic warning symbol)
		$SocialMediaLinksDetected = $ResultsJSON.data.links #This tells us if any social media links were found for your site (Need to elaborate on this) (This is a good thing)
		$PageLoadTimeDeltas = $ResultsJSON.data.timing #This tells us all of the timings for the website such as load times, etc. Need to dig deeper to give deltas and make them graphed so users know if the time is good or bad.
		$ResourceStats = $ResultsJSON.stats.resourcestats #This tells us what all resources are loaded for the page and it sizes, this will help us let the users know the size of thier site, if they need caching etc.
		$TLSStats = $ResultsJSON.stats.tlsStats #This tells us what TLS protocol and encryptionthe site is using, need to research whats the recommended based on site.
		$ServerStats = $ResultsJSON.stats.serverstats #This tells us what server technology we are using. Need to elaborate more.
		$DomainStats = $ResultsJSON.stats.domainstats #This tells us what domains this website talks to. Maybe create a safe list and not so safe list.
		$RegDomainStats = $ResultsJSON.stats.regdomainstats #Not quite sure what the hell this is
		$SecureRequests = $ResultsJSON.stats.secureRequests
		$SecurePercentage = $ResultsJSON.stats.securePercentage
		$IPv6Percentage = $ResultsJSON.stats.IPv6Percentage
		$UniqueCountries = $ResultsJSON.stats.uniqCountries
		$TotalLinks = $ResultsJSON.stats.totalLinks
		$Malicious = $ResultsJSON.stats.malicious
		$AdBlocked = $ResultsJSON.stats.adBlocked
		$IPStats = $ResultsJSON.stats.ipStats
		
	}
	Else
	{
		Write-Output "Something Went Wrong And Your Scan Results Request Returned A Status Code: $SiteScanResults"
	}
}
Else
{
	Write-Output "Something Went Wrong And Your Site Scan Request Returned A Status Code: $($SiteRequest.StatusCode)"
}

#return $($ResultsJSON)
Out-File -Encoding Ascii -FilePath $res -inputObject $($SiteScanResults.Content)
