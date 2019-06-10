# This toolkit will help you determine URL redirect final destinations and decoding url shorteners.
# All while doing it from the safety of your commandline.
# Version 0.1

function Resolve-Url
{

  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory)]
    [string] $URL
  )

  # Build a Web Request
  $Request = [System.Net.WebRequest]::Create($url )

  #Don't Allow Auto Redirects, We Don't Want To Render Final Destination Code
  $Request.AllowAutoRedirect=$false

  #Get The Response In Case It's Redirecting
  $Response = $Request.GetResponse()

  #Retrieve The URL It's Pointing To From the Header
  $URL = $Response.GetResponseHeader("Location")

  #Cleanup The Object From Memory
  $Response.Close()
  $Response.Dispose()

  #Return The Final URL
  Return $URL

}
