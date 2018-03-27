#Import User List
$UserList = Import-CSV C:\Userlist.csv

#Create Object To Store Data In
$UserInfoObject = @()

ForEach ($User in $UserList) {

	Write-Host "Processing User - $($User.DisplayName)"
	$UserInfo = "" | Select DisplayName, SamAccountName, UserPrincipalName, O365License
	$UserInfo.DisplayName = $($User.DisplayName)
	$UserInfo.SamAccountName = $($User.SamAccountName)
	$UserInfo.UserPrincipalName = $($User.UserPrincipalName)
	$UserInfo.O365License = $((Get-MSOLUser -UserPrincipalName $($User.UserPrincipalName)).Licenses | Select AccountSKUID -ExpandProperty AccountSKUID)

	$UserInfoObject += $UserInfo
}

$UserInfoObject | Export-CSV –NoTypeInformation C:\Temp\UserLicensesValidation.csv
