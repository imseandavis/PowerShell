# UCF Citation Scraper
# Scrapes Unified Compliance Policy Citations From The Website And Dumps Them Into a Database
# Version: 1.17
# By: Sean Davis

# Variables
$User = "YourUsername"
$Password = "YourPassword"
$ControlList = ""
$BaseURL = "https://www.unifiedcompliance.com/products/search-controls/control"
$CurrentControlNumber = 0
$MaxControlNumber = 14661 #Last Known Control In Database

#Init The DB Connection
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$SQLQuery = @()
$ConnectionString = "server=192.168.1.10;port=3307;database=UCF;uid=$User;pwd=$Password"
$MySQLConnection = New-Object MySql.Data.MySqlClient.MySqlConnection($ConnectionString)

# Connect To The DB
try
{
	$MySQLConnection.Open()
}
catch
{
	Write-Warning "Could Not Connect To Database!"
	Write-Warning "Error: " + $Error[0].ToString()
	Break;
}

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
			Write-Host "Process Citations $ControlID"
			$CCount = 0
			
			ForEach ($CitationItem in $CitationList | Select-Object -Skip 1)
			{
				
				"Citation $CCount"
				
				# Parse Data And Put Into A Custom Object
				#Nasty Parse Fixer Due To Windows Crappy UTF-8 Translation of ISO 8859-1 Conversions
				$UTF8 = [System.Text.Encoding]::GetEncoding(65001)
				$ISO88591 = [System.Text.Encoding]::GetEncoding(28591) #ISO 8859-1 ,Latin-1
				$WrongBytes = $UTF8.GetBytes($($CitationItem -Replace('<STRONG>', '') -Replace('</STRONG>', '') -Replace('</LI></UL><BR>', '')).replace("'","\'"))
				$RightBytes = [System.Text.Encoding]::Convert($UTF8,$ISO88591,$WrongBytes)
				$Citation = $null = $UTF8.GetString($RightBytes)
				
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
				
				$CCount++
			}
		}
				
		# Increment Control Number
		$CurrentControlNumber++
	}
}
While ($CurrentControlNumber -le $MaxControlNumber)
