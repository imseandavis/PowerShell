#Gravatar URL : https://www.gravatar.com/205e460b479e2e5b48aec07710c08d50.json

#Gravatar Icon In Powershell
$Email = "imseandavis@gmail.com"

#Convert The Email To MD5 Hash
$StringBuilder = New-Object System.Text.StringBuilder
[System.Security.Cryptography.HashAlgorithm]::Create('MD5').ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Email))| ForEach {[Void]$StringBuilder.Append($_.ToString("x2"))}
$Hash = $StringBuilder.ToString()
