	#Set Backup Path, This Could Be Scripted Or Hardcoded
	$BackupNetworkPath = "1.2.3.4\BackupPath"

	#Create A One Time Backup For OS Reload Purposes
	Write-Host " - Creating One Time Backup For OS Reload Purposes..."
	#Creating The Policy
	Write-Host "     - Creating One Time Backup Policy..."
	$OneTimePolicy=New-WBPolicy
	#Set Target To Mapped Network Backup Drive
	Write-Host "     - Set Target To Network Share..."
	$OneTimeBackupTargetVolume=New-WBbackupTarget –NetworkPath $BackupNetworkPath
	#Add Target To The Policy
	Write-Host "     - Add Target To Backup Policy..."
	Add-WBBackupTarget –Policy $OneTimePolicy –Target $OneTimeBackupTargetVolume -WA SilentlyContinue | Out-Null
	#Add Data Drive To The Backup
	Write-Host "     - Add All Data Drives To The Backup Policy..."
	$DataVolume = Get-WBVolume -AllVolumes
	Add-WBVolume -Policy $OneTimePolicy -Volume $DataVolume | Out-Null 
	#Set Bare Metal Recovery Option
	Write-Host "     - Set Bare Metal Restore Option To True..."
	Add-WBBareMetalRecovery –Policy $OneTimePolicy
	#Start OS Reload Backup Job
	Write-Host "     - Start One Time Backup Policy..."
	Start-WBBackup –Policy $OneTimePolicy | Out-Null
	#Rename Bare Metal Backup To OS Reload For Future Storage
	Write-Host "     - Rename Backup To OS Reload For Archiving Purposes..."
	$OSReloadImage = Get-ChildItem $BackupNetworkPath\WindowsImageBackup | ForEach-Object {$_.Name}
	Rename-Item $BackupNetworkPath\WindowsImageBackup\$OSReloadImage $BackupNetworkPath\WindowsImageBackup\OSReloadImage
  
