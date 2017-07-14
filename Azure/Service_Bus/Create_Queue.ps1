# Check if queue already exists
$CurrentQ = Get-AzureRmServiceBusQueue -ResourceGroup $ResGrpName -NamespaceName $Namespace -QueueName $QueueName

if($CurrentQ)
{
    Write-Host "The queue $QueueName already exists in the $Location region:"
}
else
{
    Write-Host "The $QueueName queue does not exist."
    Write-Host "Creating the $QueueName queue in the $Location region..."
    New-AzureRmServiceBusQueue -ResourceGroup $ResGrpName -NamespaceName $Namespace -QueueName $QueueName -EnablePartitioning $True
    $CurrentQ = Get-AzureRmServiceBusQueue -ResourceGroup $ResGrpName -NamespaceName $Namespace -QueueName $QueueName
    Write-Host "The $QueueName queue in Resource Group $ResGrpName in the $Location region has been successfully created."
    
    #Configure Queue
    Write-Host "Configuring the $QueueName queue in the $Location region..."
    $CurrentQ.DeadLetteringOnMessageExpiration = $True
    $CurrentQ.MaxDeliveryCount = 7
    $CurrentQ.MaxSizeInMegabytes = 2048
    $CurrentQ.EnableExpress = $True
    Set-AzureRmServiceBusQueue -ResourceGroup $ResGrpName -NamespaceName $Namespace -QueueName $QueueName -QueueObj $CurrentQ
    Write-Host "The $QueueName queue in Resource Group $ResGrpName in the $Location region has been successfully configured."
}
