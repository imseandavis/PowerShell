@" 
<html>
	<head>

        <!-- CSS -->
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
		<link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/animate.min.css" rel="stylesheet">
        <link href="css/form.css" rel="stylesheet">
        <link href="css/calendar.css" rel="stylesheet">	
        <link href="css/style.css" rel="stylesheet">
		<link href="css/icons.css" rel="stylesheet">		
        <link href="css/generics.css" rel="stylesheet">
		<link href="css/infoboxes.css" rel="stylesheet">
		
		<!-- Javascript -->
		<script src='js/jquery-1.11.1.min.js'></script>
		<script src='js/isotope.pkgd.min.js'></script>
		<script src="js/scripty.js"></script>
		<script src="js/scripty2.js"></script>
        <script src="js/bootstrap.min.js"></script>
		<script src="js/functions.js"></script>

		<link href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css" rel="stylesheet">
		<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

		<!-- Tooltip Mouse Tracker Script -->
		<script>
		`$(function() {
			`$( document ).tooltip({
				track: true,
				open: function( event, ui ) {
					ui.tooltip.animate({ }, "fast" );
				}
			});
		});
		</script>
		
		<style>
			::selection {
				background: #8C8C8C; /* WebKit/Blink Browsers */
			}
			
			::-moz-selection {
				background: #8C8C8C; /* Gecko Browsers */
			}
		</style>

	</head>
	
	<body style="background-color: black; color: white; padding-left: 15px; padding-top: 10px; padding-bottom: 10px;">
	
	$(
	#Grab The API Parameters
	$PostCommand = $PoSHQuery.Command
	$Path = $PoSHQuery.Path
	
	#See If Any Parameters Were Specified
	If($PostCommand -ne $null)
	{
		
		#Process The Parameter Passe
		Switch ($PostCommand)
		{
			"GetLogs"
			{			
				#Verify A Path Was Passed
				If($Path -ne $null)
				{
					#Check To Verify The Path Passed Was A Directory
					If(Test-Path $Path -PathType Container)
					{
						#Validate The Path Is A Log File Path (Ends In Logs)
						If($Path -like "*logs")
						{
							#Validate The Path Has At Least 1 Log File In It
							If((Get-ChildItem $Path).Count -ge 1)
							{
								try
								{
									#Clear Log Variable
									$LogContents = $null

									#Set Base Counter
									$TabCounter = 0
									$ContentCounter = 0
									
									#Get Log File List From Path
									$LogFiles = Get-ChildItem $Path | Sort
				
									#Open The Content Container
									"<div class='tab-container tile media'>"
									
									#Open The Tab Box Header
										"<ul class='tab pull-left tab-vertical nav nav-tabs'>"
										
									#Create A Tab For First File Found - Active Tab
									ForEach($LogFile in $($LogFiles | Select -First 1))
									{
											#Write Tab Header Name Based On File Name
											#NOTE: The .Replace Sanitized the Name And Fixes A Bug Where Periods, Special Characters And Spaces Cause The Modal Not To Display The Text
											"<li class='active'><a href='#$($LogFile.BaseName.Replace('.', '').Replace(' ', '').Replace('_', '').Replace('-', ''))_Active'>$($LogFile.BaseName)</a></li>"
									}
									
									#Create A Tab For All Other Files Found
									ForEach($LogFile in $($LogFiles | Select -Skip 1))
									{
											#Increment Tab Counter
											$TabCounter++
											
											#Write Tab HeaderName Based On File Name
											"<li><a href='#$($LogFile.BaseName)$($TabCounter)'>$($LogFile.BaseName)</a></li>"
									}
									
									#Close The Tab Box Header
										"</ul>"
									
									#Open The Tab Content Header
										"<div class='tab-content media-body'>"
									
									#Create Tab Content For First File Found - Active Tab
									ForEach($LogFile in $($LogFiles | Select -First 1))
									{ 
										#Get The Content Of The PowerShell Script And Write To <PRE> Tag
										$LogContents = Get-Content $Path\$($LogFile.Name)
											#NOTE: The .Replace Sanitized the Name And Fixes A Bug Where Periods, Special Characters And Spaces Cause The Modal Not To Display The Text
											"<div class='tab-pane active' id='$($LogFile.BaseName.Replace('.', '').Replace(' ', '').Replace('_', '').Replace('-', ''))_Active'>"
												"<pre style='color: white'>$($LogFile.Name) </br></br>$($LogContents | Out-String)</pre>"
											"</div>"
									}
									
									#Create Tab Content For All Other Files Found
									ForEach($LogFile in $($LogFiles | Select -Skip 1))
									{
										#Increment Content Count To Match Tab
										$ContentCounter++
										
										#Get The Content Of The PowerShell Script And Write To <PRE> Tag
										$LogContents = Get-Content $Path\$($LogFile.Name)
											"<div class='tab-pane' id='$($LogFile.BaseName)$($ContentCounter)'>"
												"<pre style='color: white'>$($LogFile.Name) </br></br></br>$($LogContents | Out-String)</pre>"
											"</div>"
									}

									#Close The Tab Content Header
										"</div>"
										
									#Close The Content Container
									"</div>"
								}
								catch
								{
									"<font color='Red'>Error: An Error Occured During An Attempt To Get The Contents of $LogFile @ $Path </font>"
								}
							}
							Else
							{
								"No Log Files Were Found For $Path"
							}
						}
						Else
						{
							"<font color='Red'> Error: This Script Folder Contains An Invalid Log File Structure."
						}
					}
					Else
					{
						"<font color='Red'> Error: Invalid Path</font> </br></br> $Path is not a valid directory folder! Please ensure you are passing a path to a folder."
					}
				}
				Else
				{
					"<font color='Red'> Error: No Path Was Specified! Please specify a log file path and try again! </font>"
				}
			}
			
			"ViewCode"
			{
				#Check To See A Path Was Passed
				If($Path -ne $null)
				{
					#Get The Contents Of File Path Passed
					If(Test-Path $Path)
					{
						If($Path -like "*.ps1")
						{
							try
							{
								#Get The Content Of The PowerShell Script
								$FileContents = Get-Content $Path
							
								#Surround The Contents In A <PRE> Tags To Properly Format The Text And Apply The Proper CSS
								"<pre style='color: white'>$($FileContents | Out-String)</pre>"
							}
							catch
							{
								"<font color='Red'>Error: An Error Occured During An Attempt To Get The Contents of $Path </font>"
							}
						}
						Else
						{
							"<font color='Red'> Error: You Specified A Valid Path But The Path Is Not A Valid PowerShell Script </font>"
						}
					}
					Else
					{
						"<font color='Red'> Error: Invalid Path</font> </br></br> $Path is not a valid path!"
					}
				}
				Else
				{
					"<font color='Red'> Error: No Path Was Specified! Please specify a file path and try again! </font>"
				}
			}
			
			"ShowExample" {"Congratulations! You Have Invoked The Example API."}
			
			default  {"<font color='Red'> Unrecognized Command Passed. Please Verify The Command You Are Attempting To Process Exists. </font>"}
		}
	}
	Else
	{
		"<font color='Red'> Error: No Command Was Passed To The API, Please Try Again.</font> </br></br> Chances are your URL is not passing parameters to this script. </br></br> The following is an example of a proper parameter being passed, feel free to try this as it's a valid example: </br></br></br> <a href='api.ps1?Command=ShowExample'>api.ps1?Command=ShowExample</a>"
	}
	)
	</body>
	
</html>
"@