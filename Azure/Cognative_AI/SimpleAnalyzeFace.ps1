# Variables
$SubscriptionID = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" #Azure Subscription ID
$Image = "C:\Path\To\File\file.jpg" #Path To Image You Want to Analyze
$URIBase = "https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/analyze" #Cognative Service URL
$RequestParameters = "visualFeatures=Categories,Tags,Faces,ImageType,Description,Color,Adult" #Cognative Service Parameters

# Assemblies
Add-Type -AssemblyName System.Net.Http

#Construct The URL
$URI = $URIBase + "?" + $RequestParameters
 
# Convert Image To Byte Array For Upload
$ImageData = Get-Content $Image -Encoding Byte 
 
# Construct Content Header
$Content = [System.Net.Http.ByteArrayContent]::new($ImageData)
$Content.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue ]::new("application/octet-stream")
 
# Init A Web Client
$Webclient = [System.Net.Http.HttpClient]::new()
$Webclient.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key",$SubscriptionID)
 
# Make A Cognitive Services Request
$Response = $Webclient.PostAsync($URI, $Content).Result
$Result = $Response.Content.ReadAsStringAsync(). Result
 
# Convert JSON To PowerShell Object
$Data = $Result | ConvertFrom-JSON
 
# Display Cognative Results
$Data.Description.Captions
$Data.Faces | Out-String
$Data.Description.Tags
