Function Show-SendConnectorConfig {
	$dataArray = @()
	Get-SendConnector | Where-Object{$_.SourceTransportServers -match "exhub"} | ForEach-Object{
	$conn_Name = $_.name
	$conn_whenChanged = $_.whenchanged
	$conn_DNSRoutingEnabled = $_.DNSRoutingEnabled
	$conn_smarthosts = $_.smarthosts
		$_.addressspaces | Foreach-Object{
			$entryObject = New-Object PSObject
			$entryObject | Add-Member NoteProperty Connector ($conn_Name)
			$entryObject | Add-Member NoteProperty LastModified ($conn_whenChanged)
			$entryObject | Add-Member NoteProperty Address ($_.address)
			$entryObject | Add-Member NoteProperty Cost ($_.cost)
			$entryObject | Add-Member NoteProperty DNSRouting ($conn_DNSRoutingEnabled)
			$entryObject | Add-Member NoteProperty SmartHosts ($conn_smarthosts)
			$dataArray += $entryObject
			}
	}

	$dataArray | Sort-Object Address
}