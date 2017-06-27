#Gravatar Icon In Powershell
#Gravatar URL : https://secure.gravatar.com/avatar/237f9c44d3a4e5ae2274eab736e3231c

#Define Variables
$Email = "imseandavis@gmail.com"

#Convert The Email To MD5 Hash
$StringBuilder = New-Object System.Text.StringBuilder
[System.Security.Cryptography.HashAlgorithm]::Create('MD5').ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Email))| ForEach {[Void]$StringBuilder.Append($_.ToString("x2"))}
$Hash = $StringBuilder.ToString()

#Get Profile Info
$ProfileRequest = (Invoke-RestMethod -URI https://www.gravatar.com/$Hash.json).Entry

#Display Profile Info
Write-Host "Profile ID: $($ProfileRequest.ID)"
Write-Host "Profile URL: $($ProfileRequest.ProfileURL)"
Write-Host "Profile UserName: $($ProfileRequest.PreferredUserName)"
Write-Host "Profile Thumbnail URL: $($ProfileRequest.ThumbnailURL)"
Write-Host "Profile Name: $($ProfileRequest.Name.Formatted)"
Write-Host "Profile About Me: $($ProfileRequest.AboutMe)"
