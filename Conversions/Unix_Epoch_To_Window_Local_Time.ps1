#This script will convert unix epoch time to windows local time format.
#Can be useful when getitng dates from unix systems / API's

$UnixEpochTime = 1484784000000
$Date = Get-Date "1/1/1970"
$UnixTime = $UnixEpochTime / 1000
$date.AddSeconds($UnixTime).ToLocalTime()
