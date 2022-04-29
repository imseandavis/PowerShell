@"
<!DOCTYPE html>
<!--[if IE 9 ]><html class="ie9"><![endif]-->
    
	<head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
        <meta name="format-detection" content="telephone=no">
        <meta charset="UTF-8">

        <title>Windows Team Toolkit</title>
		 
        <!-- CSS -->
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
		
		<link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/animate.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <link href="css/form.css" rel="stylesheet">
        <link href="css/calendar.css" rel="stylesheet">	
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
		
		<!-- Scheduled Task -->
		<script>
		`$("[rel=scheduledtask]").popover({
			trigger : 'click',  
			placement : 'top', 
			html: 'true',
			template: '<div class="popover"><div class="arrow"></div>'+
					  '<h3 class="popover-title"></h3><div class="popover-content">'+
					  '</div><div class="popover-footer"></div></div>'
		});
		</script>

    </head>
	
    <body id="skin-blur-night">

        <div class="clearfix"></div>
        </br>
		
		<!-- Notification Panel -->
		<div class="notification-bar">  
			<input id="hide" type="radio" name="bar" value="hide">  
			<input id="show" type="radio" name="bar" value="show" checked="checked">
			<label for="hide">hide</label>  
			<label for="show">show</label>  
			<div class="notification-text">
				<center> <a data-toggle='modal' href='#WhatsNew'><img src="img/logo.png" style="left: 10px; padding-right: 25px" /></a> </center>
			</div>  
		</div>
		
		<!-- View Code Modal For What's New Start -->
		<div class='modal fade' id='WhatsNew' tabindex='-1' role='dialog' aria-hidden='true'>
			<div class='modal-dialog modal-xxlg'>
				<div class='modal-content'>
					<div class='modal-header'>
						<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>
						<h4 class='modal-title'>What's New</h4>
					</div>
					<div class='modal-body'>
						<p>v2.1 - Code optimization and beautification and several bug fixes. Consolidation and removal of unneeded files/code from the Scripty source code.</p>
						<p>v2.0 - Scripty Major Upgrade - New documentation put on SharePoint on Scripty and it's use. How to guide for creating new scripts and template system created. Finally, a rewrite of the Scripty core was done to provide dynamic content loading, reducing loading times by over 5000%.</p>
						<p>v1.8 - Reworked CSS and HTML templates and fixed several bugs will code display and logs that would break views.</p>
						<p>v1.5 - Integrated ISOTOPE to dynamically search scripts and resort script icons based on filter</p>
						<p>v1.2 - Added compliance view view</p>
						<p>v1.2 - Added log view</p>
						<p>v1.2 - Added code view</p>
						<p>v1.1 - Added ability to manage and maintain multiple companies scripts.</p>
						<p>v1.0 - Scripty goes live!</p>
						<p>v0.5 - Scripty now recognizes a defined file structure and can identify scripts.</p>
						<p>v0.2 - Scripty css refined and styles finalized.</p>
						<p>v0.1 - Scripty framework designed and base html code established. </p>
					</div>
					<div class='modal-footer'>
						<button type='button' class='btn btn-sm' data-dismiss='modal'>Close</button>
					</div>
				</div>
			</div>
		</div>
		<!-- View Code Modal For What's New End-->
		
		</br>&nbsp;</br></br>
		
        <!-- Content -->
        <section id="content" class="container">

			<div class="block-area" id="content-boxes">
                <h3 class="search-bar"><input type="text" class="main-search" id="quicksearch" placeholder="Click Here To Filter Scripts"></h3> 
				
				<!--
				<div id="filters" class="button-group">
					<button class="button is-checked" data-filter="*">show all</button>
					<button class="button" data-filter=".vm">VM Actions</button>
					<button class="button" data-filter=".storage">Storage Actions</button>
				</div>
				-->
				
			</div>
				
			<!-- Content Boxes -->
            <div class="block-area" id="content-boxes">
				
				<div class="row">
					
					<div class='isotope'>
                    
					$(
						#Variables
						$Counter = 0
						$ScriptsDir = 'C:\Scripts'
						$Server = $((((GWMI Win32_ComputerSystem).Name).ToString()).ToLower())
						Import-Module ScheduledTasks
						$ScheduledTasks = Get-ScheduledTask -TaskPath '\'
						
						ForEach($CompanyFolder in Get-ChildItem $ScriptsDir)
						{
							ForEach($TechnologyFolder in $(Get-ChildItem $ScriptsDir\$($CompanyFolder.Name)))
							{
								ForEach($ScriptFolder in $(Get-ChildItem $ScriptsDir\$($CompanyFolder.Name)\$($TechnologyFolder.Name)))
								{
									ForEach($Script in $(Get-ChildItem $ScriptsDir\$($CompanyFolder.Name)\$($TechnologyFolder.Name)\$($ScriptFolder.Name) | Where {! $_.PSIsContainer -and $_.Extension -eq ".ps1"}))
									{
										#Increment The ID Counter
										$Counter++
										
										#Calculate Dynamic Variables
										$ScriptFullPath = "$ScriptsDir\$($CompanyFolder.Name)\$($TechnologyFolder.Name)\$($ScriptFolder.Name)\$($Script.Name)"
										$ScriptRootDir = "$ScriptsDir\$($CompanyFolder.Name)\$($TechnologyFolder.Name)\$($ScriptFolder.Name)"
										$ScriptLogDir = "$ScriptsDir\$($CompanyFolder.Name)\$($TechnologyFolder.Name)\$($ScriptFolder.Name)\Logs"
										$ScriptLogDirHTML = "C:\\Scripts\\$($CompanyFolder.Name)\\$($TechnologyFolder.Name)\\$($ScriptFolder.Name)\\Logs"
										
										#Generate The Portlets For The Dashboard
										
										"<div class='element-item script' data-category='vm'>"
											"<!-- <a href='#' target='_blank'> -->"
												"<p class='icon' ><i class='fa fa-desktop fa-2x'></i></p>"
												"<p class='name'>$($Script.BaseName)</p>"
												"<p class='company'>Company: $CompanyFolder</p>"
												"<p class='technology'>Technology: $TechnologyFolder</p>"
												"<p class='updatedby'>Last Updated By: $($UpdatedBy)</p>"
												"<p class='moreinfo'>"
													"<a data-toggle='modal' href='#modalViewCode$($Counter)' class='btn btn-sm'><i class='fa fa-file-powerpoint-o'> View Code</i></a>"
													"<a data-toggle='modal' href='#modalCompliance$($Counter)' class='btn btn-sm'><i class='fa fa-check-circle'> Compliance</i></a>"
													"<a data-toggle='modal' href='#modalLogs$($Counter)' class='btn btn-sm'><i class='fa fa-files-o'> Logs</i></a>"
												"</p>"
											"<!-- </a> -->"
										"</div>"
										
										"<!-- View Code Modal For $($Script.BaseName) Start -->"
										"<div class='modal fade' id='modalViewCode$($Counter)' tabindex='-1' role='dialog' aria-hidden='true'>"
											"<div class='modal-dialog modal-xxlg'>"
												"<div class='modal-content'>"
													"<div class='modal-header'>"
														"<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>"
														"<h4 class='modal-title'>Code View | Script Name: $($Script.BaseName) | Last Updated By: $($UpdatedBy) </h4>"
													"</div>"
													"<div class='modal-body Code$($Counter)'>"
														"Click To View Code <div class='codePath$($Counter)' style='visibility: hidden'>api.ps1?Command=ViewCode&Path=$ScriptFullPath</div>"
														"<script>"
															"`$('div.Code$($Counter)').click(function() {"
																"`$( this ).replaceWith(`"<iframe src='`" + `$('div.codePath$($Counter)').text() + `"' frameborder='0' seamless='seamless' width='100%' height='500' />`"); });"
														"</script>"
													"</div>"
													"<div class='modal-footer'>"
														"<button type='button' class='btn btn-sm' data-dismiss='modal'>Close</button>"
													"</div>"
												"</div>"
											"</div>"
										"</div>"
										"<!-- View Code Modal For $($Script.BaseName) End-->"
										
										"<!-- Compliance Modal For $($Script.BaseName) Start -->"
										"<div class='modal fade' id='modalCompliance$($Counter)' tabindex='-1' role='dialog' aria-hidden='true'>"
											"<div class='modal-dialog modal-xxlg'>"
												"<div class='modal-content'>"
													"<div class='modal-header'>"
														"<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>"
														"<h4 class='modal-title'>Compliance View | Script Name: $($Script.BaseName) | Last Updated By: $($UpdatedBy) </h4>"
													"</div>"
													"<div class='modal-body'>"
														"<div class='tab-container tile'>"
															"<ul class='nav tab nav-tabs'>"
																"<li class='active'><a href='#ScriptInfo$($Counter)'></a></li>"
															"</ul>"                         
															"<div class='tab-content'>"
																"<div class='tab-pane active' id='ScriptInfo$($Counter)'>"
																	"<p>"

																		"<b>Script Info</b><br>"
																		
																		#Determine Script Name
																		$( 
																			#Find Script Base Name By Parsing Path
																			If($Script.BaseName -ne $null)
																			{
																				#Script Base Name Was Sucessfully Parsed, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Internal - File Path Parse'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For Script Name - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to unknown characters in the script name. Please verify all non ASCII characters are removed from the script name.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																			}
																			
																			#Write The Script Name To The Dashboard
																			"Script Name: $($Script.BaseName)</br>"
																		)
																		
																		#Determine Script Version
																		$( 
																			#Get The Script Version From Script Header
																			$ScriptVersion = ""
																			If($(Select-String $ScriptFullPath -Pattern '#!Version:') -ne $null)
																			{
																				#Found A Pattern Match
																				$ScriptVersion = "$((((Select-String $ScriptFullPath -Pattern '#!Version').Line).Split(':')[1]).TrimStart())"
																				
																				#Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Script Header'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#No Pattern Match Found, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check failed due to a missing line or value in the script header for the #!Version property.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																			}
																			
																			#Write The Script Verison To The Dashboard
																			"Script Version: $($ScriptVersion) </br>"
																		)

																		#Determine Script Documentation URL
																		$( 
																			#Init Variable
																			$DocURL = ""
																			
																			#Get The Script Version From Script Header
																			If($(Select-String $ScriptFullPath -Pattern '#!DocumentationURL:') -ne $null)
																			{
																				#Found A Pattern Match, Determine The URL
																				$DocURL = $((((Select-String $ScriptFullPath -Pattern '#!DocumentationURL').Line).Split(':')[1]).TrimStart())
																				
																				#Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Script Header'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#No Pattern Match Found, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='Script Header Missing Value: #!DocumentationURL property.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																			}
																			
																			#Write The Script Verison To The Dashboard
																			"Document URL: $($DocURL) </br>"
																		)
																		
																		"</br><b>File Info</b><br>"
																		
																		#Determine Script File Name
																		$( 
																			#Find Script File Name By Parsing Path
																			If($($Script.Name) -ne $null)
																			{
																				#Script Name Was Sucessfully Parsed, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Internal - File Path Parse'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For Script Name - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to unknown characters in the script name. Please verify all non ASCII characters are removed from the script name.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																			}
																			
																			#Write The Script File Name To The Dashboard
																			"Script File Name: $($Script.Name) </br>"
																		)

																		#Determine Full Script Local Path
																		$( 
																			#Find Script Local Path By Parsing Path
																			If($ScriptFullPath -ne $null)
																			{
																				#Full Script Local Path Was Sucessfully Parsed, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Internal - File Path Parse'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For Script Path - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to unknown characters in the file path or script name. Please verify all non ASCII characters are removed from the script name.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																		
																			}
																			
																			#Write The Script Full Local Path To The Dashboard
																			"Script Full Local Path: $ScriptFullPath </br>"
																		)
																		
																		#Determine Full Script Shared File Path
																		$( 
																			#Calculate The Shared File Script Path
																			$ShareFilePath = "\\$Server\C`$\$($ScriptRootDir.Trim('C:\'))"
																			
																			#Calculate Script Shared File Path Quering Current Server And Parsing Path
																			If($ShareFilePath -ne $null)
																			{
																				#Full Script Shared Path Was Sucessfully Queried And Parsed, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Internal - File Path Parse'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For Script Path - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed if the local server name could not be queried or if there are unknown characters in the file path or script name. Please verify all non ASCII characters are removed from the scirpt name. ' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																			}
																			
																			#Write The Script Full Shared File Name To The Dashboard
																			"Script Share File Path: $($ShareFilePath) </br>"
																		)

																		#Determine Script Log Directory
																		$(
																			#Get The Script Log Path From Script Header
																			If($ScriptLogDir -ne $null)
																			{
																				#Script Log Directory Was Sucessfully Parsed, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Internal - File Path Parse'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For Script Log Directory - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to unknown characters in the file path or script name. Please verify all non ASCII characters are removed from the script name.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																		
																			}
																			
																			#Write The Script Log Directory To The Dashboard
																			"Script Log Directory: $($ScriptLogDir) </br>"
																		)
																		
																		"</br><b>Access Info</b><br>"
																		
																		#Determine Script Created By User
																		$( 
																			#Init Variable
																			$CreatedBy = ""
																			
																			#Get The Creator Information
																			If($(Select-String $ScriptFullPath -Pattern '#!CreatedBy:') -ne $null)
																			{																			
																				#Creator Information Was Found In Script Header
																				$CreatedBy = "$((((Select-String $ScriptFullPath -Pattern '#!CreatedBy:').Line).Split(':')[1]).TrimStart())"
																					
																				#Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Script Header'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Script Info Missing, Fall Back On File Properties 
																				$CreatedBy = "$(((Get-ACL $ScriptFullPath).Owner).Split('\')[1])"
																			
																				#If The File Properties Shows SYSTEM as creator, This Means The File Was Deployed By GPO
																				If($CreatedBy -eq "SYSTEM")
																				{
																					$CreatedBy = "GPO Deployed Script"
																					#Create A Passed Button With Datasource
																					"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Internal - File Path Parse'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																				}
																				Else
																				{
																					try
																					{
																						#Info Was Missing From The Script And Wasn't Deployed Via GPO, Parse The Owner And Lookup In AD.
																						$CreatedBy = $((Get-ADUser -Property DisplayName $((Get-ACL $ScriptFullPath).Owner).Split('\')[1]).DisplayName)
																						
																						#Create A Passed Button With Datasource
																						"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check has been flagged as a warning, no script header information was found, so fallback to the file ACL was used. This information may not be correct. Please update the script header with the #!CreatedBy property in the script header to fix this issue.' title='Source: File ACL - Owner'><font color='yellow'><i class='fa fa-exclamation-circle'></i></font></button>"
																					}
																					catch
																					{
																						#AD Translation Failed, Use Owner Property
																						$CreatedBy = $((Get-ACL $ScriptFullPath).Owner)
																						
																						#Create A Passed Button With Datasource
																						"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check has been flagged as a warning, no script header information was found, so fallback to the file ACL was used. In addition, Active Directory could not translate the ACL user to a user account! This information may not be correct. Please update the script header with the #!CreatedBy property in the script header to fix this issue.' title='Source: File ACL - Owner'><font color='yellow'><i class='fa fa-exclamation-circle'></i></font></button>"
																					}
																				}
																			}

																			#Write The Created By User Information To The Dashboard
																			"Created By: $($CreatedBy) </br>"
																		)
																		
																		#Determine Script Created On Value
																		$( 
																			#Get The Created On Date
																			$CreatedOn = (Get-Item $ScriptFullPath).CreationTime.DateTime
																			
																			#Check Compliance Value - Created On
																			If($CreatedOn -ne $null)
																			{
																				#The Created On Value Was Sucessfully Parsed From The File ACL, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: File ACL - CreationTime'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For ACL Creation Time - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check failed due to no value found on the file ACL for the CreationTime property.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																		
																			}
																				"Created On: $($CreatedOn) </br>"
																		)

																		#Determine Script Contact Email Address
																		$( 
																			#Init Variable
																			$ContactEmail = ""
																			
																			#Get The Script Version From Script Header
																			If($(Select-String $ScriptFullPath -Pattern '#!ContactEmail:') -ne $null)
																			{
																				#Found A Pattern Match
																				$ContactEmail = "$((((Select-String $ScriptFullPath -Pattern '#!ContactEmail').Line).Split(':')[1]).TrimStart())"
																				
																				#Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Script Header'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#No Pattern Match Found, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check failed due to a missing line or value in the script header for the #!ContactEmail property.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																			}
																			
																			#Write The Script Verison To The Dashboard
																			"Contact Email: $($ContactEmail) </br>"
																		)

																		#Determine Script Updated By User
																		$( 
																			#Get The Updated By User Information
																			$UpdatedBy = "$(((Get-ACL $ScriptFullPath).Owner).Split('\')[1])"
																			
																			#If The File Properties Shows SYSTEM as creator, This Means The File Was Deployed By GPO
																			If($UpdatedBy -eq "SYSTEM")
																			{
																				$CreatedBy = "GPO Deployed Script"
																				#Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: File ACL - Owner'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				try
																				{
																					#Info Was Missing From The Script And Wasn't Deployed Via GPO, Parse The Owner And Lookup In AD.
																					$UpdatedBy = $((Get-ADUser -Property DisplayName $((Get-ACL $ScriptFullPath).Owner).Split('\')[1]).DisplayName)
																					
																					#Create A Passed Button With Datasource
																					"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: File ACL - Owner'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																				}
																				catch
																				{
																					#AD Translation Failed, Use Owner Property
																					$UpdatedBy = $((Get-ACL $ScriptFullPath).Owner)
																					
																					#Create A Passed Button With Datasource
																					"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: File ACL - Owner'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																				}
																			}
																			
																			#Write The Created By User Information To The Dashboard
																			"Updated By: $($UpdatedBy) </br>"
																		)
																		
																		#Determine Script Updated On Value
																		$( 
																			#Get The Updated On Date
																			$UpdatedOn = (Get-Item $ScriptFullPath).LastWriteTime.DateTime
																			
																			#Check Compliance Value - Updated On
																			If($UpdatedOn -ne $null)
																			{
																				#The Created On Value Was Sucessfully Parsed From The File ACL, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: File ACL - LastWriteTime'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For ACL Creation Time - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check failed due to no value found on the file ACL for the LastWriteTime property.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																		
																			}
																			
																			#Write The Updated On Information To The Dashboard
																			"Updated On: $($UpdatedOn) </br>"
																		)
																		
																		#Determine Script Last Accesed On Value
																		$( 
																			#Get The Updated On Date
																			$LastAccessed = (Get-Item $ScriptFullPath).LastAccessTime.DateTime
																			
																			#Check Compliance Value - Last Accessed
																			If($UpdatedOn -ne $null)
																			{
																				#The Created On Value Was Sucessfully Parsed From The File ACL, Create A Passed Button With Datasource
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: File ACL - LastAccessTime'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			Else
																			{
																				#Error Or Empty Value Found For ACL Creation Time - Should Never Occur, Create A Failed Button With Error Info
																				"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check failed due to no value found on the file ACL for the LastAccessTime property.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																			}
																			
																			#Write The Last Accesed Information To The Dashboard
																			"Last Accessed On: $($LastAccessed) </br>"
																		)

																		"</br><b>Dependencies Info</b><br>"																	
																		
																		#Determine Scheduled Tasks
																		$( 
																			#Find Any Related Scheduled Tasks
																			$Tasks = $ScheduledTasks | Where {$_.Actions.Arguments -like "*$($Script.Name)*"}

																			#Process All Tasks
																			If($Tasks -ne $null)
																			{
																				#Tasks Were Found, Enumerate And Format The Output
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Scheduled Task Lookup'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																				"Scheduled Tasks: "
																				
																				#Create Entries For Each Task
																				$TaskCounter = 0
																				ForEach($Task in $Tasks)
																				{
																					#Increment Task Counter
																					$TaskCounter++
																					
																					#Add Formatting Between Items If There Are More Than One
																					If($TaskCounter -lt $($Tasks | Measure-Object).Count)
																					{
																						#Add The Formatting For The Next Item
																						$TaskFormatting = ', '
																					}
																					Else
																					{
																						#Last Item Encountered, Close The Format
																						$TaskFormatting = ' </br>'
																					}
																					
																					#Create Entry For The Task
																					"<a href='#' rel='scheduledtask' class='underline pover' data-toggle='popover' data-placement='top' data-content='<b>Current State:</b> $($Task.State) </br><b>Last Run Time:</b> $($(($Task | Get-ScheduledTaskInfo).LastRunTime))</br><b>Last Result:</b> $($(($Task | Get-ScheduledTaskInfo).LastTaskResult)) </br></br><b>Name:</b> $($Task.TaskName) </br><b>Author:</b> $($Task.Author) </br></br><b>Description:</b> $($Task.Description) </br></br>' title='Scheduled Task Info' > $($Task.TaskName)</a>$TaskFormatting"
																				}
																			}
																			Else
																			{
																				#No Tasks Were Found
																				"<button class='btn btn-sm pover btn-small' data-toggle='popover' data-placement='top' title='Source: Scheduled Task Lookup'><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																				"Scheduled Tasks: N/A </br>"
																			}
																		)
																		
																		#Determine Event Logs Used
																		$( 
																			#Init Variable
																			$EventLogs = $(Select-String $ScriptFullPath -Pattern "Write-EventLog")
																			
																			#See If The Script Is Using Any Event Logs To Do Logging
																			If($EventLogs -ne $null)
																			{
																				#Create An Event Log List to Put The List Of Logs Into
																				$EventLogList = @()
																				
																				#Loop Through All Matches Found And Extract The List If Logs Written To
																				ForEach($EventLog in $EventLogs)
																				{
																					#Add The Detected Log To the Array
																					$EventLogList += ($EventLog).Line.Split(' ')[2]
																				}
																				
																				#Event Logs Were Found, Create Status Button
																				#"<button class='btn btn-sm pover btn-small' disabled><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																				#"Event Logs: $($EventLogList | Select -Unique) </br>"
																			}
																			Else
																			{
																				#"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check failed due to an empty value for the file name. </br></br>Fix: This was likely due to the script being unable to be trimmed or the extension was unknown.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																				#"Event Logs: None </br>"
																			}
																		)

																		#Determine Script Registry Keys
																		$( 
																			#Check Compliance Value - Registry Keys
																			If($RegistryKeys -ne $null)
																			{
																				"<button class='btn btn-sm pover btn-small' disabled><font color='green'><i class='fa fa-check-circle'></i></font></button>"
																			}
																			ElseIf($RegistryKeys -like "None")
																			{
																				#"<button class='btn btn-sm pover btn-small' disabled><font color='yellow'><i class='fa fa-exclamation-circle'></i></font></button>"
																			}
																			Else
																			{
																				#"<button class='btn btn-sm pover btn-small' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check failed due to an empty value for the file name. </br></br>Fix: This was likely due to the script being unable to be trimmed or the extension was unknown.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button>"
																		
																			}
																				#"Registry Keys: $($RegistryKeys) </br>"
																		)
																	"</p>"
																		
																"</div>"
															"</div>"
														"</div>"
													"</div>"
													"<div class='modal-footer'>"
														"<button type='button' class='btn btn-sm' data-dismiss='modal'>Close</button>"
													"</div>"
												"</div>"
											"</div>"
										"</div>"
										"<!-- Compliance Modal For $($Script.BaseName) End-->"
										
										"<!-- Logs Modal For $($Script.BaseName) Start -->"
										"<div class='modal fade' id='modalLogs$($Counter)' tabindex='-1' role='dialog' aria-hidden='true'>"
											"<div class='modal-dialog modal-xxlg'>"
												"<div class='modal-content'>"
													"<div class='modal-header'>"
														"<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>&times;</button>"
														"<h4 class='modal-title'>Logs View | Script Name: $($Script.BaseName) | Last Updated By: $($UpdatedBy) </h4>"
													"</div>"
													"<div class='modal-body Logs$($Counter)'>"
														"Click To View Logs <div class='logPath$($Counter)' style='visibility: hidden'>api.ps1?Command=GetLogs&Path=$ScriptLogDirHTML</div>"
														"<script>"
															"`$('div.Logs$($Counter)').click(function() {"
																"`$( this ).replaceWith(`"<iframe src='`" + `$('div.logPath$($Counter)').text() + `"' frameborder='0' seamless='seamless' width='100%' height='500' />`"); });"
														"</script>"
													"</div>"
													"<div class='modal-footer'>"
														"<button type='button' class='btn btn-sm' data-dismiss='modal'>Close</button>"
													"</div>"
												"</div>"
											"</div>"
										"</div>"
										"<!-- Logs Modal For $($Script.BaseName) End-->"
									}
								}
							}
						}
					)
					
					</div>
					
                </div>
				
            </div>

		</section>
		
		<!-- Older IE Message -->
        <!--[if lt IE 9]>
            <div class="ie-block">
                <h1 class="Ops">Ooops!</h1>
                <p>You are using an outdated version of Internet Explorer, upgrade to any of the following web browser in order to access the maximum functionality of this website. </p>
                <ul class="browsers">
                    <li>
                        <a href="https://www.google.com/intl/en/chrome/browser/">
                            <img src="img/browsers/chrome.png" alt="">
                            <div>Google Chrome</div>
                        </a>
                    </li>
                    <li>
                        <a href="http://www.mozilla.org/en-US/firefox/new/">
                            <img src="img/browsers/firefox.png" alt="">
                            <div>Mozilla Firefox</div>
                        </a>
                    </li>
                    <li>
                        <a href="http://www.opera.com/computer/windows">
                            <img src="img/browsers/opera.png" alt="">
                            <div>Opera</div>
                        </a>
                    </li>
                    <li>
                        <a href="http://safari.en.softonic.com/">
                            <img src="img/browsers/safari.png" alt="">
                            <div>Safari</div>
                        </a>
                    </li>
                    <li>
                        <a href="http://windows.microsoft.com/en-us/internet-explorer/downloads/ie-10/worldwide-languages">
                            <img src="img/browsers/ie.png" alt="">
                            <div>Internet Explorer(New)</div>
                        </a>
                    </li>
                </ul>
                <p>Upgrade your browser for a Safer and Faster web experience. <br/>Thank you for your patience...</p>
            </div>   
        <![endif]-->

	</body>

</html>
"@