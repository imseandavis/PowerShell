#Ghetto Tail The Model Manager Service Log
Do {Sleep 5; Clear-Host; Get-Content "C:\Program Files (x86)\VMware\vCAC\Server\Model Manager Web\Logs\Repository.log" | Select -Last 25} While ($true)