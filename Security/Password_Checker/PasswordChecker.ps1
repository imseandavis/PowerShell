# Get Password To Examine
$Password = Read-Host
 
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
$Seen = ForEach ($PassHash in $PassHashes)
{
 If ($PassHash.StartsWith($Suffix)) { 
   [int]($$PassHash -split ':' )[-1]
   Break
 }
}
 
"Your Password: $Password has been found in {0:n0} breaches." -f $seen
