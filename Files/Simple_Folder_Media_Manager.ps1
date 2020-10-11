# Init Variables
$ScanDirectory = "\\192.168.1.10\Videos\Movies" #Update With Your Path

# Get All Files In A Directory Non Recurse
$FileList = Get-ChildItem $ScanDirectory -File
$TotalFileCount = 0
$SuccessCount = 0
$DuplicateCount = 0
$AlreadyExistsCount = 0

# Loop Through Each Movie
ForEach ($File in $FileList)
{	
	$TotalFileCount++
	
	Write-Host "Moving $($File.Name)..."

	# Create New Movie Directory Folder
	Write-Host " -Checking To See If $ScanDirectory\$($File.BaseName) Directory Exists..."
	If (!(Test-Path "$ScanDirectory\$($File.BaseName)"))
	{
		Write-Host " --Creating Directory: $ScanDirectory\$($File.BaseName)"
		New-Item -Type Directory -Path "$ScanDirectory\$($File.BaseName)" | Out-Null
	}
	
	# Verify File Doesn't Already Exist And Move It
	If(!(Test-Path "$ScanDirectory\$($File.BaseName)\$($File.Name)"))
	{
		Write-Host " -Moving File: $ScanDirectory\$($File.Name) to $ScanDirectory\$($File.BaseName)"
		Move-Item -LiteralPath "$ScanDirectory\$($File.Name)" -Destination "$ScanDirectory\$($File.BaseName)" | Out-Null
		$SuccessCount++
	}
	Else
	{
		$SourceFileSize = $File.Length
		$DestinationFileSize = (Get-ChildItem $ScanDirectory\$($File.BaseName)\$($File.Name)).Length
		
		#If The Source and Destination File Size Is The Same, Delete It
		If($SourceFileSize -eq $DestinationFileSize)
		{
			$DuplicateCount++
			
			Write-Host "  --Found Duplicate File, Deleting...: $ScanDirectory\$($File.Name)"
			Remove-Item -LiteralPath "$ScanDirectory\$($File.Name)"
		}
		Else
		{
			$AlreadyExistsCount++
			Write-Host -Foreground Yellow " --File Already Exist And Is A Different Size, Please Manually Check Which Version You Want To Keep"
		}
	}

	# Added For Cleaner Readable Output
	Write-Host ""
}

Write-Host "Session Stats"
Write-Host "-------------"
Write-Host "Total Files Handled: $TotalFileCount"
Write-Host "Successful File Moves: $SuccessCount"
Write-Host "Deleted Duplicate Files: $DuplicateCount"
Write-Host "Already Exist Conflicts: $AlreadyExistsCount"
