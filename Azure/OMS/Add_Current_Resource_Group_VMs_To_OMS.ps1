#Add All VM's In A Resource Group To OMS Dashboard
#Version: 1.2
#By: Sean Davis
#NOTES:
#After Running This Script In Order To See The Virtual Machines Linked In Log Analytics -> Virtual Machines Blade, You Will Need To Logout
#And Login Again. This Is Due To A Bug In Azure Portal As Of 8/2/2017.

#Init Variables
$SubscriptionName = "AZURE_SUBSCRIPTION_NAME_GOES_HERE" #Your Azure Tenant SubscriptionName
$WorkspaceName = "OMS_WORKSPACE_NAME_GOES_HERE" #Name Of Your OMS Workspace
$VM_Resource_Group = "RESOURCE_GROUP_NAME" #Name Of The Resource Group With The VM's You Want To Add To OMS

#Login To Azure
Login-AzureRMAccount

#Select The Azure Subscription
Select-AzureRMSubscription -SubscriptionName $SubscriptionName

#Grab Current Workspace For Resource Group
$Workspace = (Get-AzureRmOperationalInsightsWorkspace).Where({$_.Name -eq $WorkspaceName})

#Verify OMS Workspace Exists
if ($Workspace.Name -ne $WorkspaceName)
{
    Write-Error "Unable to find OMS Workspace $workspaceName. Do you need to run Select-AzureRMSubscription?"
    Break
}

#Get The Workspace ID / Keys From The Tenant
$WorkspaceID = $Workspace.CustomerId
$WorkspaceKey = (Get-AzureRmOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $Workspace.ResourceGroupName -Name $Workspace.Name).PrimarySharedKey

#Grab A List Of VM's In The Resource Group
$VMList = Get-AzureRmVM -ResourceGroupName $VM_Resource_Group

#Loop Through Each VM And Add To OMS
ForEach ($VirtualMachine in $VMList)
{
	#Get VM Location
	$Location = $VirtualMachine.Location
	Write-Debug "Found VM Location: $Location"
	
	# Add VM To OMS Workspace
	try
	{
		Write-Debug "Adding VM: $($VirtualMachine.Name)" 
		Set-AzureRmVMExtension -ResourceGroupName $VM_Resource_Group -VMName $($VirtualMachine.Name) -Name 'MicrosoftMonitoringAgent' -Publisher 'Microsoft.EnterpriseCloud.Monitoring' -ExtensionType 'MicrosoftMonitoringAgent' -TypeHandlerVersion '1.0' -Location $Location -SettingString "{'workspaceId': '$WorkspaceID'}" -ProtectedSettingString "{'workspaceKey': '$WorkspaceKey'}"
	}
	catch
	{
		Write-Host "Could Not Add Virtual Machine: $($VirtualMachine.Name)" 
	}
}
