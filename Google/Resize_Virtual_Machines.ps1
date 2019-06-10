#PREREQUISITE: MUST HAVE THE GCLOUD TOOLS INSTALLED ON THE BOX YOU ARE DOING THIS ON!!

$NewVMSize = "n1-standard-4"
$Zone = "us-east1-c"
$ServerList = gcloud compute instances list | ForEach-Object {$_.Split(' ')[0]} #Return All Servers
#$ServerList = gcloud compute instances list | ForEach-Object {$_.Split(' ')[0]} | Select -First 1 #Only Return The First Server
#$ServerList = gcloud compute instances list | findstr lly | % {$_.Split(' ')[0]}  #Only Return Search String Servers

#Process Them Serially
ForEach($ServerName in $ServerList)
{
	Write-Host "Processing $ServerName...."
	#Stop The VM
	Write-Host "-Stopping VM $ServerName"
	gcloud compute instances stop $ServerName --zone $Zone

	#Resize The VM
	Write-Host "-Resizing VM $ServerName"
	gcloud compute instances set-machine-type $ServerName --machine-type $NewVMSize --zone $Zone

	#Start The VM
	Write-Host "-Starting VM $ServerName"
	gcloud compute instances start $ServerName --zone $Zone
}


#Or Process Them Semi Serial - Faster
ForEach($ServerName in $ServerList)
{
	Write-Host "Processing $ServerName...."
	#Stop The VM
	Write-Host "-Stopping VM $ServerName"
	gcloud compute instances stop $ServerName --zone $Zone
}

ForEach($ServerName in $ServerList)
{
	#Resize The VM
	Write-Host "-Resizing VM $ServerName"
	gcloud compute instances set-machine-type $ServerName --machine-type $NewVMSize --zone $Zone
}

ForEach($ServerName in $ServerList)
{
	#Start The VM
	Write-Host "-Starting VM $ServerName"
	gcloud compute instances start $ServerName --zone $Zone
}

#Or Process Them Parallel - Fastest
#TODO WRITE SOME CODE :)
