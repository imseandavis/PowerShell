#Tail The Last 25 Lines of a Log File
$FullPathToFile = Read-Host "Full Path Of File You Want To Tail"

If (Test-Path $FullPathToFile)
{
	Do {Sleep 5; Clear-Host; Get-Content "$FullPathToFile" | Select -Last 25} While ($true)
}