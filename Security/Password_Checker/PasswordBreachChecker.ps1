# Get Password To Examine
$Password = Read-Host "What's The Password You Want To Check?"
 
# Enable All SSL protocols
[Net.ServicePointManager]::SecurityProtocol = 'Ssl3,Tls, Tls11, Tls12'
 
# Get The PASSWORD Hash
$Stream = [IO.MemoryStream]::new([Text.Encoding ]::UTF8.GetBytes($Password))
$Hash = Get-FileHash -InputStream $Stream -Algorithm SHA1
$Stream.Close()
$Stream.Dispose()
 
# Look At Hash And Regex First 5 Characters To Protect Identity
$Prefix, $Suffix = $Hash.Hash -split '(?<=^.{5})'
 
# Retrieve Passwords Matching The First 5 Hash Digits
$URL = "https://api.pwnedpasswords.com/range/$Prefix"
$Response = Invoke-RestMethod -Uri $URL -UseBasicParsing
 
# Find The Exact Matche(s)
$PassHashes = $Response -split '\r\n'
$SeenCount = ForEach ($PassHash in $PassHashes)
{
 If ($PassHash.StartsWith($Suffix)) { 
   [int]($PassHash -split ':' )[-1]
   Break
 }
}

# Inform The User If Their Password Has Been Listed
If ($SeenCount -ge 1)
{
 Write-Host -Foreground Red "Your Password: $Password has been exposed $SeenCount times."
}
Else
{
 Write-Host -Foreground Green "Congratulations! Your Password wasn't found in any breaches."
}
