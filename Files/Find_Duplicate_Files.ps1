#Create a Lookup Dictionary
$Dictionary = @{}
 
#Get A List Of Files From A Specific Directory And Loop Through Each File, Add To Dictionary, And Compare MD5 To All Others In The Dictionary 
Get-ChildItem -Path $home -Filter *.ps1 -Recurse |
  ForEach-Object {
        $hash = ($_ | Get-FileHash -Algorithm MD5).Hash
        if ($Dictionary.ContainsKey($hash))
        {
            [PSCustomObject]@{
                Original = $dict[$hash]
                Duplicate = $_.FullName
                }
        }
        else
        {
            $Dictionary[$hash]=$_.FullName
        }
    } |
    Out-GridView #Output To Grid Table
