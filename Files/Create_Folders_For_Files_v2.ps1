#Init Variables
$ScanDirectory = "C:\Movies" #Update With Your Path

# Get All Files In A Directory Non Recurse
$FileList = Get-ChildItem $ScanDirectory -File

#Create Folders For Each File
ForEach ($File in $FileList)
{	
	Write-Host "Moving $($File.Name)..."
	
	If (!(Test-Path $("$ScanDirectory\$(($File.Name).Split('.')[0])")))
	{
		#Create The New Directory
		try
		{
			Write-Host " -Creating Directory: $(`"$ScanDirectory\$(($File.Name).Split('.')[0])`")"
			New-Item -Type Directory -Path "$(`"$ScanDirectory\$(($File.Name).Split('.')[0])`")" | Out-Null
			
			#Move The Video Into The New Directory
			try
			{
				Write-Host " -Moving File: $ScanDirectory\$($File.Name)"
				Move-Item -Path "$ScanDirectory\$($File.Name)" -Destination "$(`"$ScanDirectory\$(($File.Name).Split('.')[0])`")\$($File.Name)" | Out-Null
			}
			catch
			{
				Write-Host -Foreground Yellow "Couldn't Move Movie, Manually Fix!"
				Break;
			}
		}
		catch
		{
		
		}
	}
	Else
	{
		Write-Host " -Directory Already Exists, Skipping..."
	}
}
