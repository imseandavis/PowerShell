# Crystal Knows PowerShell API v1.1
#By: Sean Davis
#Date: 9/20/2019

#NOTE: MUST USE THE API LINK YOU GET WHEN YOU GET THE TOKEN IN ORDER FOR THE PROFILE TO BE RETRIEVEABLE BY THE API

#NOTE: The Crystalknows API has been updated to a paid service for $99 a month, the first 30 calls are free, so you
#      can use this script to cut your teeth on using the API without paying.

#Define Variables
$APIToken = "YOUR API TOKEN HERE"
$EmailAddress = "USER EMAIL HERE"
$ConstructedURL = "https://api.crystalknows.com/v1/profiles/find?token=$APIToken&email=$([System.Web.HttpUtility]::UrlEncode($EmailAddress))"

#Make API Call
try
{
	$Response = Invoke-RestMethod -URI $ConstructedURL
}
catch
{
	#Process The Return Code And Inform The User
	$ResultCode = $($Error[0].Exception) #FIX THIS TO ACTUALLY PULL THE ERROR CODE
	
	Switch ($ResultCode)
	{
		"401" {"Unauthorized"}
		
		"404" { Write-Host -Foreground Yellow "Profile Not Found"}
		
		default { Write-Host -Foreground Red "Error: Result Code Not Found!"}
	}
}

#If Call Is Successful, Process And Display Data
$Profile = $Response.Data


$Name = "$($Profile.First_Name) $($Profile.Last_Name)"
$PhotoURL = $($Profile.Photo_URL)
$DISCType = $($Profile.Personalities.DISC_Type)
$EnneagramType = $($Profile.)
$DISCChartURL = $Profile.Images
$Content = $Profile.Content


#Additiional Disc Info - DISC Slide Presentations
$DISC_Dc_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-i-the-architect
$DISC_D_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-d-the-captain
$DISC_Di_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-i-the-driver
$DISC_DI_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-i-the-initiator

$DISC_Id_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-i-the-influencer
$DISC_I_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-i-the-motivator
$DISC_Is_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-i-the-encourager
$DISC_IS_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-i-the-harmonizer

$DISC_Si_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-s-the-counselor
$DISC_S_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-s-the-supporter
$DISC_Sc_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-s-the-planner
$DISC_SC_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-s-the-stabilizer

$DISC_Cs_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-c-the-editor
$DISC_C_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-c-the-analyst
$DISC_Cd_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-c-the-skeptic
$DISC_CD_SLIDE_URL = https://www.slideshare.net/crystalknows/disc-c-the-questioner
