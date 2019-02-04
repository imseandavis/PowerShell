#Date Functions / Variables To Help With Simple Date/Time Needs

#Current Date / Times
$CurrentYear = $((Get-Date).Year) #Current Year
$CurrentMonth = $((Get-Date).Month) #Current Month
$CurrentDay = $((Get-Date).Day) #Current Day

#First and Lasts
$FirstDayofCurrentMonth = 1 # :)
$LastDayofCurrentMonth = [DateTime]::DaysInMonth($CurrentYear, $CurrentMonth)

$FirstDateTimeoftheMonth = Get-Date -Day 1 -Month $CurrentMonth -Year $CurrentYear -Hour 0 -Minute 0 -Second 0
$LastDateTimeoftheMonth = Get-Date -Day $LastDayofCurrentMonth -Month $CurrentMonth -Year $CurrentYear -Hour 23 -Minute 59 -Second 59
