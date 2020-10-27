# UCF Policy Scraper
# Scrapes Unified Compliance Policies From The Website And Dumps Them Into a Database
# Version: 1.08
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

# Loop Through ControlList and Retrieve Data For Each Control
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
		$SupportingControls = @()
		$ControlID = ($Control.ParsedHTML.getElementById('divCommonControlID').innerHTML -Split('<BR>'))[1]
		
		# Check To See If The Control Name Exists
		If($Control.ParsedHTML.getElementById('h2CommonControlName').innerHTML -eq $null)
		{
			$CommonControlName = "NOT FOR USE"
		}
		Else
		{
			$CommonControlName = ($Control.ParsedHTML.getElementById('h2CommonControlName').innerHTML).replace("'","\'")
		}
		
		$CommonControlType = ($Control.ParsedHTML.getElementById('divCommonControlType').innerHTML -Split('<BR>'))[1]
		$Classification = ($Control.ParsedHTML.getElementById('divCommonControlClassification').innerHTML -Split('<BR>'))[1]
		
		#Check To See If There Are Implied Control ID'search-controls/control
		If($Control.ParsedHTML.getElementById('divSupportedCommonControls').innerHTML -match "<STRONG>This is a top level control.</STRONG>")
		{
			$SupportsImpliedControlID = $null
		}
		Else
		{
			$SupportsImpliedControlID = ((($Control.ParsedHTML.getElementById('divSupportedCommonControls').innerHTML) -Split('/">'))[1]).Split('</a>')[0]
		}
		
		#Check To See If There Are Implementation Support Controls
		If($Control.ParsedHTML.getElementById('divSupportingCommonControls').innerHTML -match "<STRONG>There are no implementation support Controls.</STRONG>")
		{
			$ImplementationSupportControlID = $null
			$SupportingControls = $null
		}
		Else
		{
			$ImplementationSupportControlList = (($Control.ParsedHTML.getElementById('divSupportingCommonControls').innerHTML) -Split('<li>'))
			
			ForEach ($SupportingControlItem in $ImplementationSupportControlList | Select-Object -Skip 1)
			{
				# Parse Data And Put Into A Custom Object
				$ImplementationSupportControlID = $null = $(($SupportingControlItem -Split('>'))[1].Split('<')[0])
				$SupportingControls += $ImplementationSupportControlID
			}
		}

		# Write Everything To The Database
		$MySQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
		$MySQLCommand.Connection = $MySQLConnection
		$MySQLCommand.CommandText = "INSERT into `controls` (`Control_ID`, `Name`, `Type`, `Classification`, `SupportsImpliedControlIDList`) VALUES('$ControlID', '$CommonControlName', '$CommonControlType', '$Classification', '$SupportingControls')"
		$RowsAffected = $MySQLCommand.ExecuteNonQuery()
		
		# Check To Make Sure The Record Was Properly Recorded
		If($RowsAffected -lt 1)
		{
			Write-Warning "Unable To INSERT Into The Database!"
			Write-Warning "Error: " + $Error[0].ToString()
		}
		else
		{
			Write-Host "Successfully Added Control #: $CurrentControlNumber"
		}
		
		# Increment Control Number
		$CurrentControlNumber++
		
		#Write-Warning "DEBUG - Implied: $($Control.ParsedHTML.getElementById('divSupportedCommonControls').innerHTML)"
		#Write-Warning "DEBUG - Implementation: $($Control.ParsedHTML.getElementById('divSupportingCommonControls').innerHTML)"
		#Write-Warning "DEBUG - MySQLCommand: $($MySQLCommand.CommandText)"
	}
}
While ($CurrentControlNumber -le $MaxControlNumber)
