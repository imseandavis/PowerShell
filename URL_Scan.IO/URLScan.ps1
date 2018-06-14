function New-URLScan
{

  params(
    $URL,
    $APIKey
  )
  #Set The TLS to 1.2
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

  #Build The Header Token
  $Header = @{"API-Key" = "$APIKey"}

  #Submit The Scan Request
  $Invoke = Invoke-WebRequest -Method POST -ContentType application/json" -Headers $Header -Body "{`"url`":`"$URL`"}" -URI "https://urlscan.io/api/v1/scan/"
 
