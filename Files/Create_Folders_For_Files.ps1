#Create Folders For Files In The Directory (Still Got A Bug With Titles That Have A Period In The Name)
Get-ChildItem -File -Path R:\Movies | Select -First 3 | ForEach-Object { New-Item -Type Directory -Name $_.Name.Split('.')[0]; Move-Item -Path $_.FullName -Destination $_.Name.Split('.')[0]}
