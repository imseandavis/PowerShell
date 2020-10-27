# Loop Through ControlList and Retrieve Citations For Each Control
Do
{
	# Clear Previous Stored Content
	$Control = ""
	
	# Get The Website Data
	$Control = Invoke-WebRequest -URI "$BaseURL/$CurrentControlNumber"

	# Break Out Each Section of Data
	If($Control.StatusCode -eq 200)
	{
		$Count = 0
		$Citations = @()
		$ControlID = ($Control.ParsedHTML.getElementById('divCommonControlID').innerHTML -Split('<BR>'))[1]
		$CitationList = ($Control.ParsedHTML.getElementById('divRelatedCitations').innerHTML) -Split('<LI>')
		
		#Check To See If There Are Citations
		If($Control.ParsedHTML.getElementById('divRelatedCitations').innerHTML -match "<STRONG>This control is an implied control and is included to maintain the legal hierarchy for your selected controls.</STRONG>")
		{
			$CitationList = "This control is an implied control and is included to maintain the legal hierarchy for your selected controls."
		}
		Else
		{
			ForEach ($CitationItem in $CitationList | Select-Object -Skip 1)
			{
				# Parse Data And Put Into A Custom Object
				$Citation = $null = $((CitationItem -Replace('<STRONG>'))
			}
		}
		
		# Write Everything To The Database
		$MySQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
		$MySQLCommand.Connection = $MySQLConnection
		$MySQLCommand.CommandText = "INSERT into `citations` (`Control_ID`, `Citation`) VALUES('$ControlID', '$Citation')"
		$RowsAffected = $MySQLCommand.ExecuteNonQuery()
		
		# Check To Make Sure The Record Was Properly Recorded
		If($RowsAffected -lt 1)
		{
			Write-Warning "Unable To INSERT Into The Database!"
			Write-Warning "Error: " + $Error[0].ToString()
		}
		else
		{
			Write-Host "Successfully Added Citation for Control #: $CurrentControlNumber"
		}
		
		# Increment Control Number
		$CurrentControlNumber++
	}
}
While ($CurrentControlNumber -le 5)
