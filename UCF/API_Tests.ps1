#Unfinished breakouts

# Specific Account Info - Pull Account Info from Your Tenant
$bearer_token = "YOURBEARERTOKEN"
$contentType = "application/json"
$url = "https://api.unifiedcompliance.com/cch-account/113/details"
$method = "GET"
$headers = @{Authorization = "Bearer $bearer_token"}
$response = Invoke-RestMethod -ContentType "$contentType" -Uri $url -Method $method -Headers $headers -UseBasicParsing
$response.ad_lists | FT

# Enumerate AD Docs from AD List - Pick An AD List and Retrieve the AD’s That The List Using (This case is 14890 (API Test)
$bearer_token = "YOURBEARERTOKEN"
$contentType = "application/json"
$url = "https://api2.unifiedcompliance.com/cch-ad-list/11907/authority-documents"
$method = "GET"
$headers = @{Authorization = "Bearer $bearer_token"}
$response = Invoke-RestMethod -ContentType "$contentType" -Uri $url -Method $method -Headers $headers -UseBasicParsing
$response | FT

We find AD List is mapped to AD Docs – 1263, 91, 92

# We find AD List is mapped to AD Docs – 1263, 91, 92 - Enumerate the Controls from The Authority Documents (This example is 1263, 91, 92)
# Enumerate AD Doc Properties
$bearer_token = "YOURBEARERTOKEN"
$contentType = "application/json"
$url = "https://api2.unifiedcompliance.com/authority-document/92/details"
$method = "GET"
$headers = @{Authorization = "Bearer $bearer_token"}
$response = Invoke-RestMethod -ContentType "$contentType" -Uri $url -Method $method -Headers $headers -UseBasicParsing
$response | FT

#Test Standrd / Citation / Controls:
1263 is a FedRamp Standard and has 130 citations and 78 controls
$Citations = $response.citations  #130 Citations
$Controls = $response.citations.control | Select * -Unique #78 Mandated Controls

# Enumerate AD Doc Properties - Enumerate Audit Items from The Authority Documents (This example is a list of audit items)
$bearer_token = "YOURBEARERTOKEN"
$contentType = "application/json"
$url = "https://api2.unifiedcompliance.com/cch-ad-list/14890/audit-items"
$method = "GET"
$headers = @{Authorization = "Bearer $bearer_token"}
$response = Invoke-RestMethod -ContentType "$contentType" -Uri $url -Method $method -Headers $headers -UseBasicParsing

# Enumerate AD Doc Properties - Enumerate Tracked Controls from The Authority Documents (This example is a list of tracked controls)
$bearer_token = "YOURBEARERTOKEN"
$contentType = "application/json"
$url = "https://api2.unifiedcompliance.com/cch-ad-list/14890/tracked-controls"
$method = "GET"
$headers = @{Authorization = "Bearer $bearer_token"}
$response = Invoke-RestMethod -ContentType "$contentType" -Uri $url -Method $method -Headers $headers -UseBasicParsing

# Enumerate AD Doc - Properties Get Tracked Control Details (This example is for degaussing)
$bearer_token = "YOURBEARERTOKEN"
$contentType = "application/json"
$url = "https://api2.unifiedcompliance.com/cch-ad-list/14890/tracked-controls/details"
$method = "GET"
$headers = @{Authorization = "Bearer $bearer_token"}
$response = Invoke-RestMethod -ContentType "$contentType" -Uri $url -Method $method -Headers $headers -UseBasicParsing

# Enumerate AD Doc Properties - Get Specific Control Details
$bearer_token = "YOURBEARERTOKEN"
$contentType = "application/json"
$url = "https://api.unifiedcompliance.com/control/123/details"
$method = "GET"
$headers = @{Authorization = "Bearer $bearer_token"}
$response = Invoke-RestMethod -ContentType "$contentType" -Uri $url -Method $method -Headers $headers -UseBasicParsing




