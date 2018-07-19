#Script To Write Junk Data For SQL DB

#Define Variables
$SQLQuery = @()
$TableName = "OverviewInfo"
$StartDate = (Get-Date).AddDays(-364)

	do
	{
		$StartDate = $StartDate.AddDays(1)
		$SQLQuery += "INSERT INTO $TableName(Date,vCenter,vCenter_Version,Datacenter_Count,Cluster_Count,Host_Count,Datastore_Count,VM_Count,Template_Count,Resource_Pool_Count,Consolidation_Ratio) VALUES ('$StartDate','dd01','$(Get-Random -InputObject 5.0, 5.1)','$(Get-Random -Min 1 -Max 2)','$(Get-Random -Min 1 -Max 10)','$(Get-Random -Min 11 -Max 20)','$(Get-Random -Min 5 -Max 11)','$(Get-Random -Min 213 -Max 1879)','$(Get-Random -Min 1 -Max 16)','1','$(Get-Random -Min 1 -Max 25)');"
		$SQLQuery += "INSERT INTO $TableName(Date,vCenter,vCenter_Version,Datacenter_Count,Cluster_Count,Host_Count,Datastore_Count,VM_Count,Template_Count,Resource_Pool_Count,Consolidation_Ratio) VALUES ('$StartDate','vcenter01','$(Get-Random -InputObject 5.0, 5.1)','$(Get-Random -Min 1 -Max 2)','$(Get-Random -Min 1 -Max 10)','$(Get-Random -Min 11 -Max 20)','$(Get-Random -Min 5 -Max 11)','$(Get-Random -Min 213 -Max 1879)','$(Get-Random -Min 1 -Max 16)','1','$(Get-Random -Min 1 -Max 25)');"
		$SQLQuery += "INSERT INTO $TableName(Date,vCenter,vCenter_Version,Datacenter_Count,Cluster_Count,Host_Count,Datastore_Count,VM_Count,Template_Count,Resource_Pool_Count,Consolidation_Ratio) VALUES ('$StartDate','vc01','$(Get-Random -InputObject 5.0, 5.1)','$(Get-Random -Min 1 -Max 2)','$(Get-Random -Min 1 -Max 10)','$(Get-Random -Min 11 -Max 20)','$(Get-Random -Min 5 -Max 11)','$(Get-Random -Min 213 -Max 1879)','$(Get-Random -Min 1 -Max 16)','1','$(Get-Random -Min 1 -Max 25)');"
		$SQLQuery += "INSERT INTO $TableName(Date,vCenter,vCenter_Version,Datacenter_Count,Cluster_Count,Host_Count,Datastore_Count,VM_Count,Template_Count,Resource_Pool_Count,Consolidation_Ratio) VALUES ('$StartDate','vblock01','$(Get-Random -InputObject 5.0, 5.1)','$(Get-Random -Min 1 -Max 2)','$(Get-Random -Min 1 -Max 10)','$(Get-Random -Min 11 -Max 20)','$(Get-Random -Min 5 -Max 11)','$(Get-Random -Min 213 -Max 1879)','$(Get-Random -Min 1 -Max 16)','1','$(Get-Random -Min 1 -Max 25)');"
		$SQLQuery += "INSERT INTO $TableName(Date,vCenter,vCenter_Version,Datacenter_Count,Cluster_Count,Host_Count,Datastore_Count,VM_Count,Template_Count,Resource_Pool_Count,Consolidation_Ratio) VALUES ('$StartDate','vcsv01','$(Get-Random -InputObject 5.0, 5.1)','$(Get-Random -Min 1 -Max 2)','$(Get-Random -Min 1 -Max 10)','$(Get-Random -Min 11 -Max 20)','$(Get-Random -Min 5 -Max 11)','$(Get-Random -Min 213 -Max 1879)','$(Get-Random -Min 1 -Max 16)','1','$(Get-Random -Min 1 -Max 25)');"
		$SQLQuery += "INSERT INTO $TableName(Date,vCenter,vCenter_Version,Datacenter_Count,Cluster_Count,Host_Count,Datastore_Count,VM_Count,Template_Count,Resource_Pool_Count,Consolidation_Ratio) VALUES ('$StartDate','vdivc01','$(Get-Random -InputObject 5.0, 5.1)','$(Get-Random -Min 1 -Max 2)','$(Get-Random -Min 1 -Max 10)','$(Get-Random -Min 11 -Max 20)','$(Get-Random -Min 5 -Max 11)','$(Get-Random -Min 213 -Max 1879)','$(Get-Random -Min 1 -Max 16)','1','$(Get-Random -Min 1 -Max 25)');"
		$SQLQuery += "INSERT INTO $TableName(Date,vCenter,vCenter_Version,Datacenter_Count,Cluster_Count,Host_Count,Datastore_Count,VM_Count,Template_Count,Resource_Pool_Count,Consolidation_Ratio) VALUES ('$StartDate','vdivc02','$(Get-Random -InputObject 5.0, 5.1)','$(Get-Random -Min 1 -Max 2)','$(Get-Random -Min 1 -Max 10)','$(Get-Random -Min 11 -Max 20)','$(Get-Random -Min 5 -Max 11)','$(Get-Random -Min 213 -Max 1879)','$(Get-Random -Min 1 -Max 16)','1','$(Get-Random -Min 1 -Max 25)');"
	}
	until ($($StartDate) -gt $(Get-Date))

$SQLQuery | Out-File C:\Temp\JunkData.txt
