$Sites = Get-ChildItem IIS:\Sites

ForEach ($Site in $Sites){
	#Get The Bindings For Each Site
	Write-Host "Website Found: " + $Site.Name
	$Site.Bindings.Collection
}
