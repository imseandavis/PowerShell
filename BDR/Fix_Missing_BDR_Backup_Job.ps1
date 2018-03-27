#Get OS
$OS = GWMI Win32_OperatingSystem

#Set Zenith Path
if  ($OS.Version -le 6) {Set-Location "C:\Program Files\Zenith\Zenith Infotech"} else {Set-Location "C:\Program Files (x86)\Zenith\Zenith Infotech"}

#Register The Zenith DLLs
Write-Host "Registering The Required DLL's..."
Start-Process "regsvr32.exe" "activationautomation.dll" -Wait
Start-Process "regsvr32.exe" " keyfileautomation.dll" -Wait

#Set Backup Job Creator Path
if  ($OS.Version -le 6) {Set-Location "C:\Program Files\SAAZOD"} else {Set-Location "C:\Program Files (x86)\SAAZOD"}

#Create My Backup Job
Write-Host "Regenerating BDR Backup Job Schedule..."
Start-Process "ZJobMgt.exe" "abc@123" -Wait

#Let The User Know Everything Is Done
Write-Host "New Backup Job Generated! Check The BDR!"
