#Declare Variables
$WebsiteRoot = "D:\Websites\PowerShell\engineer.website.com\http"
$WebsiteUser = $PoshUserName.Split('\')[1]
$ServerName = $PoshQuery.ServerName
$QueryType = $PoshQuery.QueryType
$SQLServer = "SQLSERVER"
$Database = "Infrastructure"

#Init VM Info Variables
$Info_vCenter = $null
$Info_vCenter_Label = $null
$Info_vCenter_Cluster_Count = $null
$Info_vCenter_Host_Count = $null
$Info_vCenter_Datastore_Count = $null
$Info_vCenter_VM_Count = $null
$Info_Datacenter = $null
$Info_Cluster = $null
$Info_Cluster_EVC_Mode = $null
$Info_Host = $null
$Info_Host_Power_State = $null
$Info_Host_Version = $null
$Info_Host_Model = $null
$Info_Host_Manufacturer = $null
$Info_Host_CPU_Socket_Count = $null
$Info_Host_CPU_Cores_Per_Socket_Count = $null
$Info_Host_CPU_Total_Cores_Count = $null
$Info_Host_CPU_Total_MHz = $null
$Info_Host_CPU_Usage_MHz = $null
$Info_Host_CPU_Free_MHz = $null
$Info_Host_CPU_Percent_Used = $null
$Info_Host_RAM_Total_GB = $null
$Info_Host_RAM_Usage_GB = $null
$Info_Host_RAM_Free_GB = $null
$Info_Host_RAM_Percent_Used = $null
$Info_Datastore = $null
$Info_Datastore_FreeSpaceGB = $null
$Info_Datastore_UsedSpaceGB = $null
$Info_Datastore_CapacityGB = $null
$Info_Datastore_Percent_Used = $null
$Info_VM_vCenter_Name = $null
$Info_VM_Host_Name = $null
$Info_VM_DNS_Name = $null
$Info_VM_Hardware_Version = $null
$Info_VM_Power_State = $null
$Info_VM_BIOS_Firmware_Type = $null
$Info_VM_EVC_Mode = $null
$Info_VM_Last_Modified_Time = $null
$Info_VM_Last_Modified_By = $null
$Info_VM_Fault_Tolerance_Policy = $null
$Info_VM_Annotations_Notes = $null
$Info_VM_Annotations_Created_On = $null
$Info_VM_Annotations_Created_By = $null
$Info_VM_Annotations_Owner = $null
$Info_VM_Annotations_Server_Role = $null
$Info_VM_CPU_Socket_Count = $null
$Info_VM_CPU_Cores_Per_Socket_Count = $null
$Info_VM_CPU_Total_Cores_Count = $null
$Info_VM_CPU_Hot_Add_Enabled = $null
$Info_VM_CPU_Hot_Remove_Enabled = $null
$Info_VM_Memory_Total_MB = $null
$Info_VM_Memory_Overhead_MB = $null
$Info_VM_Memory_Hot_Add_Enabled = $null
$Info_VM_Memory_Hot_Plug_Limit_MB = $null
$Info_VM_Tools_Version = $null
$Info_VM_Tools_Status = $null
$Info_VM_Tools_Version_Status = $null
$Info_VM_Tools_Running_Status = $null
$Info_VM_Tools_Upgrade_Policy = $null
$Info_VM_OS = $null
$Info_VM_Container_OS = $null
$Info_VM_Swap_File_Policy = $null
$Info_VM_Alarms_Enabled = $null
$Info_VM_Compliance_Flags = $null
$Info_VM_IP_Address = $null
$Info_VM_NIC_Type = $null
$Info_VM_Connection_State = $null
$Info_VM_MAC_Address = $null
$Info_VM_Port_Group = $null
$Info_VM_VLAN = $null
$Info_VM_CPU_Stats = $null
$Info_VM_RAM_Stats = $null
$Info_VM_Disk_Stats = $null
$Info_VM_Net_Stats = $null
$Info_VM_Datastore_List = $null
$Info_VM_Snapshot_List = $null
$Info_VM_Task_List = $null

Function Get-RedirectedUrl {
 
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )
 
    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()
 
    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}

#Grab Server Info Based On Query Type
Switch ($QueryType)
{	
	"ServerName"
	{
		#Grab SQL Data And Convert To JSON Array
		$SQLConnection = New-Object System.Data.SqlClient.SqlConnection("Data Source=$SQLServer;Initial Catalog=$Database; Integrated Security=SSPI")
		$SQLQuery = "SELECT * FROM Compute_Info	WHERE VM_vCenter_Name = '$($ServerName)'"
		$Adapter = New-Object System.Data.SqlClient.SQLDataAdapter ($SQLQuery, $SQLConnection)
		$QueryResponse = New-Object System.Data.DataTable
		$Result = $Adapter.Fill($QueryResponse)

		#Validate The Server Requested Exists
		If($($QueryResponse.vCenter).Count -eq 0)
		{
			$ServerExists = $False
		}
		Else
		{
			$ServerExists = $True

			#Populate All The Variables
			$Info_vCenter = $QueryResponse.vCenter
			$Info_vCenter_Label = $QueryResponse.vCenter_Label
			$Info_vCenter_Cluster_Count = $QueryResponse.vCenter_Cluster_Count
			$Info_vCenter_Host_Count = $QueryResponse.vCenter_Host_Count
			$Info_vCenter_Datastore_Count = $QueryResponse.vCenter_Datastore_Count
			$Info_vCenter_VM_Count = $QueryResponse.vCenter_VM_Count
			$Info_Datacenter = $QueryResponse.Datacenter
			$Info_Cluster = $QueryResponse.Cluster
			$Info_Cluster_EVC_Mode = $QueryResponse.Cluster_EVC_Mode
			$Info_Host = $QueryResponse.Host
			$Info_Host_Power_State = $QueryResponse.Host_Power_State
			$Info_Host_Version = $QueryResponse.Host_Version
			$Info_Host_Model = $QueryResponse.Host_Model
			$Info_Host_Manufacturer = $QueryResponse.Host_Manufacturer
			$Info_Host_CPU_Socket_Count = $QueryResponse.Host_CPU_Socket_Count
			$Info_Host_CPU_Cores_Per_Socket_Count = $QueryResponse.Host_CPU_Cores_Per_Socket_Count
			$Info_Host_CPU_Total_Cores_Count = $QueryResponse.Host_CPU_Total_Cores_Count
			$Info_Host_CPU_Total_MHz = $QueryResponse.Host_CPU_Total_MHz
			$Info_Host_CPU_Usage_MHz = $QueryResponse.Host_CPU_Usage_MHz
			$Info_Host_CPU_Free_MHz = $QueryResponse.Host_CPU_Free_MHz
			$Info_Host_CPU_Percent_Used = $QueryResponse.Host_CPU_Percent_Used
			$Info_Host_RAM_Total_GB = $QueryResponse.Host_RAM_Total_GB
			$Info_Host_RAM_Usage_GB = $QueryResponse.Host_RAM_Usage_GB
			$Info_Host_RAM_Free_GB = $QueryResponse.Host_RAM_Free_GB
			$Info_Host_RAM_Percent_Used = $QueryResponse.Host_RAM_Percent_Used
			$Info_Datastore = $QueryResponse.Datastore
			$Info_Datastore_FreeSpaceGB = $QueryResponse.Datastore_FreeSpaceGB
			$Info_Datastore_UsedSpaceGB = $QueryResponse.Datastore_UsedSpaceGB
			$Info_Datastore_CapacityGB = $QueryResponse.Datastore_CapacityGB
			$Info_Datastore_Percent_Used = $QueryResponse.Datastore_Percent_Used
			$Info_VM_vCenter_Name = $QueryResponse.VM_vCenter_Name
			$Info_VM_Host_Name = $QueryResponse.VM_Host_Name
			$Info_VM_DNS_Name = $QueryResponse.VM_DNS_Name
			$Info_VM_Hardware_Version = $QueryResponse.VM_Hardware_Version
			$Info_VM_Power_State = $QueryResponse.VM_Power_State
			$Info_VM_BIOS_Firmware_Type = $QueryResponse.VM_BIOS_Firmware_Type
			$Info_VM_EVC_Mode = $QueryResponse.VM_EVC_Mode
			$Info_VM_Fault_Tolerance_Policy = $QueryResponse.VM_Fault_Tolerance_Policy
			$Info_VM_Annotations_Notes = $QueryResponse.VM_Annotations_Notes
			$Info_VM_Annotations_Created_On = $QueryResponse.VM_Annotations_Created_On
			$Info_VM_Annotations_Created_By = $QueryResponse.VM_Annotations_Created_By
			$Info_VM_Annotations_Owner = $QueryResponse.VM_Annotations_Owner
			$Info_VM_Annotations_Server_Role = $QueryResponse.VM_Annotations_Server_Role
			$Info_VM_CPU_Socket_Count = $QueryResponse.VM_CPU_Socket_Count
			$Info_VM_CPU_Cores_Per_Socket_Count = $QueryResponse.VM_CPU_Cores_Per_Socket_Count
			$Info_VM_CPU_Total_Cores_Count = $QueryResponse.VM_CPU_Total_Cores_Count
			$Info_VM_CPU_Hot_Add_Enabled = $QueryResponse.VM_CPU_Hot_Add_Enabled
			$Info_VM_CPU_Hot_Remove_Enabled = $QueryResponse.VM_CPU_Hot_Remove_Enabled
			$Info_VM_Memory_Total_MB = $QueryResponse.VM_Memory_Total_MB
			$Info_VM_Memory_Overhead_MB = $QueryResponse.VM_Memory_Overhead_MB
			$Info_VM_Memory_Hot_Add_Enabled = $QueryResponse.VM_Memory_Hot_Add_Enabled
			$Info_VM_Memory_Hot_Plug_Limit_MB = $QueryResponse.VM_Memory_Hot_Plug_Limit_MB
			$Info_VM_Tools_Version = $QueryResponse.VM_Tools_Version
			$Info_VM_Tools_Status = $QueryResponse.VM_Tools_Status
			$Info_VM_Tools_Version_Status = $QueryResponse.VM_Tools_Version_Status
			$Info_VM_Tools_Running_Status = $QueryResponse.VM_Tools_Running_Status
			$Info_VM_Tools_Upgrade_Policy = $QueryResponse.VM_Tools_Upgrade_Policy
			$Info_VM_OS = $QueryResponse.VM_OS
			$Info_VM_Container_OS = $QueryResponse.VM_Container_OS
			$Info_VM_Swap_File_Policy = $QueryResponse.VM_Swap_File_Policy
			$Info_VM_Alarms_Enabled = $QueryResponse.VM_Alarms_Enabled
			$Info_VM_Compliance_Flags = $QueryResponse.VM_Compliance_Flags
			$Info_VM_IP_Address = $QueryResponse.VM_IP_Address
			$Info_VM_NIC_Type = $QueryResponse.VM_NIC_Type
			$Info_VM_Connection_State = $QueryResponse.VM_Connection_State
			$Info_VM_MAC_Address = $QueryResponse.VM_MAC_Address
			$Info_VM_Port_Group = $QueryResponse.VM_Port_Group
			$Info_VM_VLAN = $QueryResponse.VM_VLAN
			
			$Info_VM_CPU_Ready_Stats = $QueryResponse.VM_CPU_Ready_Stats
			If($Info_VM_CPU_Ready_Stats.Count -eq 10) {$Info_VM_CPU_Ready_Stats = $Info_VM_CPU_Ready_Stats.Split(',')}
			
			$Info_VM_CPU_Stats = $QueryResponse.VM_CPU_Stats
			If($Info_VM_CPU_Stats.Count -eq 10) {$Info_VM_CPU_Stats = $Info_VM_CPU_Stats.Split(',')}
			
			$Info_VM_RAM_Stats = $QueryResponse.VM_RAM_Stats
			If($Info_VM_RAM_Stats -eq 10) {$Info_VM_RAM_Stats = $Info_VM_RAM_Stats.Split(',')}
			
			$Info_VM_Disk_Stats = $QueryResponse.VM_Disk_Stat
			If($Info_VM_Disk_Stats -eq 10) {$Info_VM_Disk_Stats = $Info_VM_Disk_Stats.Split(',')}
			
			$Info_VM_Net_Stats = $QueryResponse.VM_Net_Stats
			If($Info_VM_Net_Stats -eq 10) {$Info_VM_Net_Stats = $Info_VM_Net_Stats.Split(',')}
			
			$Info_VM_Datastore_List = $QueryResponse.VM_Datastore_List
			$Info_VM_Snapshot_List = $QueryResponse.VM_Snapshot_List
			$Info_VM_Task_List = $QueryResponse.VM_Task_List

		}
	}
	
	"IP"
	{
		#Grab SQL Data And Convert To JSON Array
		$SQLConnection = New-Object System.Data.SqlClient.SqlConnection("Data Source=$SQLServer;Initial Catalog=$Database; Integrated Security=SSPI")
		$SQLQuery = "SELECT * FROM Compute_Info	WHERE VM_IP_Address = '$($ServerName)'"
		$Adapter = New-Object System.Data.SqlClient.SQLDataAdapter ($SQLQuery, $SQLConnection)
		$QueryResponse = New-Object System.Data.DataTable
		$Result = $Adapter.Fill($QueryResponse)

		#Validate The Server Requested Exists
		If($($QueryResponse.VM_IP_Address).Count -eq 0)
		{
			$ServerExists = $False
		}
		Else
		{
			$ServerExists = $True

			#Populate All The Variables
			$Info_vCenter = $QueryResponse.vCenter
			$Info_vCenter_Label = $QueryResponse.vCenter_Label
			$Info_vCenter_Cluster_Count = $QueryResponse.vCenter_Cluster_Count
			$Info_vCenter_Host_Count = $QueryResponse.vCenter_Host_Count
			$Info_vCenter_Datastore_Count = $QueryResponse.vCenter_Datastore_Count
			$Info_vCenter_VM_Count = $QueryResponse.vCenter_VM_Count
			$Info_Datacenter = $QueryResponse.Datacenter
			$Info_Cluster = $QueryResponse.Cluster
			$Info_Cluster_EVC_Mode = $QueryResponse.Cluster_EVC_Mode
			$Info_Host = $QueryResponse.Host
			$Info_Host_Power_State = $QueryResponse.Host_Power_State
			$Info_Host_Version = $QueryResponse.Host_Version
			$Info_Host_Model = $QueryResponse.Host_Model
			$Info_Host_Manufacturer = $QueryResponse.Host_Manufacturer
			$Info_Host_CPU_Socket_Count = $QueryResponse.Host_CPU_Socket_Count
			$Info_Host_CPU_Cores_Per_Socket_Count = $QueryResponse.Host_CPU_Cores_Per_Socket_Count
			$Info_Host_CPU_Total_Cores_Count = $QueryResponse.Host_CPU_Total_Cores_Count
			$Info_Host_CPU_Total_MHz = $QueryResponse.Host_CPU_Total_MHz
			$Info_Host_CPU_Usage_MHz = $QueryResponse.Host_CPU_Usage_MHz
			$Info_Host_CPU_Free_MHz = $QueryResponse.Host_CPU_Free_MHz
			$Info_Host_CPU_Percent_Used = $QueryResponse.Host_CPU_Percent_Used
			$Info_Host_RAM_Total_GB = $QueryResponse.Host_RAM_Total_GB
			$Info_Host_RAM_Usage_GB = $QueryResponse.Host_RAM_Usage_GB
			$Info_Host_RAM_Free_GB = $QueryResponse.Host_RAM_Free_GB
			$Info_Host_RAM_Percent_Used = $QueryResponse.Host_RAM_Percent_Used
			$Info_Datastore = $QueryResponse.Datastore
			$Info_Datastore_FreeSpaceGB = $QueryResponse.Datastore_FreeSpaceGB
			$Info_Datastore_UsedSpaceGB = $QueryResponse.Datastore_UsedSpaceGB
			$Info_Datastore_CapacityGB = $QueryResponse.Datastore_CapacityGB
			$Info_Datastore_Percent_Used = $QueryResponse.Datastore_Percent_Used
			$Info_VM_vCenter_Name = $QueryResponse.VM_vCenter_Name
			$Info_VM_Host_Name = $QueryResponse.VM_Host_Name
			$Info_VM_DNS_Name = $QueryResponse.VM_DNS_Name
			$Info_VM_Hardware_Version = $QueryResponse.VM_Hardware_Version
			$Info_VM_Power_State = $QueryResponse.VM_Power_State
			$Info_VM_BIOS_Firmware_Type = $QueryResponse.VM_BIOS_Firmware_Type
			$Info_VM_EVC_Mode = $QueryResponse.VM_EVC_Mode
			$Info_VM_Fault_Tolerance_Policy = $QueryResponse.VM_Fault_Tolerance_Policy
			$Info_VM_Annotations_Notes = $QueryResponse.VM_Annotations_Notes
			$Info_VM_Annotations_Created_On = $QueryResponse.VM_Annotations_Created_On
			$Info_VM_Annotations_Created_By = $QueryResponse.VM_Annotations_Created_By
			$Info_VM_Annotations_Owner = $QueryResponse.VM_Annotations_Owner
			$Info_VM_Annotations_Server_Role = $QueryResponse.VM_Annotations_Server_Role
			$Info_VM_CPU_Socket_Count = $QueryResponse.VM_CPU_Socket_Count
			$Info_VM_CPU_Cores_Per_Socket_Count = $QueryResponse.VM_CPU_Cores_Per_Socket_Count
			$Info_VM_CPU_Total_Cores_Count = $QueryResponse.VM_CPU_Total_Cores_Count
			$Info_VM_CPU_Hot_Add_Enabled = $QueryResponse.VM_CPU_Hot_Add_Enabled
			$Info_VM_CPU_Hot_Remove_Enabled = $QueryResponse.VM_CPU_Hot_Remove_Enabled
			$Info_VM_Memory_Total_MB = $QueryResponse.VM_Memory_Total_MB
			$Info_VM_Memory_Overhead_MB = $QueryResponse.VM_Memory_Overhead_MB
			$Info_VM_Memory_Hot_Add_Enabled = $QueryResponse.VM_Memory_Hot_Add_Enabled
			$Info_VM_Memory_Hot_Plug_Limit_MB = $QueryResponse.VM_Memory_Hot_Plug_Limit_MB
			$Info_VM_Tools_Version = $QueryResponse.VM_Tools_Version
			$Info_VM_Tools_Status = $QueryResponse.VM_Tools_Status
			$Info_VM_Tools_Version_Status = $QueryResponse.VM_Tools_Version_Status
			$Info_VM_Tools_Running_Status = $QueryResponse.VM_Tools_Running_Status
			$Info_VM_Tools_Upgrade_Policy = $QueryResponse.VM_Tools_Upgrade_Policy
			$Info_VM_OS = $QueryResponse.VM_OS
			$Info_VM_Container_OS = $QueryResponse.VM_Container_OS
			$Info_VM_Swap_File_Policy = $QueryResponse.VM_Swap_File_Policy
			$Info_VM_Alarms_Enabled = $QueryResponse.VM_Alarms_Enabled
			$Info_VM_Compliance_Flags = $QueryResponse.VM_Compliance_Flags
			$Info_VM_IP_Address = $QueryResponse.VM_IP_Address
			$Info_VM_NIC_Type = $QueryResponse.VM_NIC_Type
			$Info_VM_Connection_State = $QueryResponse.VM_Connection_State
			$Info_VM_MAC_Address = $QueryResponse.VM_MAC_Address
			$Info_VM_Port_Group = $QueryResponse.VM_Port_Group
			$Info_VM_VLAN = $QueryResponse.VM_VLAN
			$Info_VM_CPU_Ready_Stats = $QueryResponse.VM_CPU_Ready_Stats
			If($Info_VM_CPU_Ready_Stats.Count -eq 10) {$Info_VM_CPU_Ready_Stats = $Info_VM_CPU_Ready_Stats.Split(',')}
			$Info_VM_CPU_Stats = $QueryResponse.VM_CPU_Stats
			If($Info_VM_CPU_Stats.Count -eq 10) {$Info_VM_CPU_Stats = $Info_VM_CPU_Stats.Split(',')}
			$Info_VM_RAM_Stats = $QueryResponse.VM_RAM_Stats
			If($Info_VM_RAM_Stats -eq 10) {$Info_VM_RAM_Stats = $Info_VM_RAM_Stats.Split(',')}
			$Info_VM_Disk_Stats = $QueryResponse.VM_Disk_Stat
			If($Info_VM_Disk_Stats -eq 10) {$Info_VM_Disk_Stats = $Info_VM_Disk_Stats.Split(',')}
			$Info_VM_Net_Stats = $QueryResponse.VM_Net_Stats
			If($Info_VM_Net_Stats -eq 10) {$Info_VM_Net_Stats = $Info_VM_Net_Stats.Split(',')}
			$Info_VM_Datastore_List = $QueryResponse.VM_Datastore_List
			$Info_VM_Snapshot_List = $QueryResponse.VM_Snapshot_List
			$Info_VM_Task_List = $QueryResponse.VM_Task_List

		}
	}
	
	default
	{$QueryType = "ServerName"}
	
}

#Add User Action To Compliance Log
try {$SQLConnection.Open()} catch {$null}
$SQLCommand = $SQLConnection.CreateCommand()
$SQLCommand.CommandText = "INSERT INTO Compliance_Visitor_Log (Date, UserAccount, Reason) VALUES ('$(Get-Date)', '$WebsiteUser', 'Obtained Server Info For $ServerName')"
$UserActivityLogResult = $SQLCommand.ExecuteNonQuery()

If($ServerExists)
{
@" 
<html>
	
	<head>
	
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta name="format-detection" content="telephone=no">
		<meta charset="UTF-8">
		<meta http-equiv="cache-control" content="max-age=0" />
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="expires" content="0" />
		<meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
		<meta http-equiv="pragma" content="no-cache" />
		
		<title>Server Information</title>

		<!-- CSS -->
		<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
		<link href="css/bootstrap.css" rel="stylesheet">
		<link href="css/style.css" rel="stylesheet">
		<link href="css/ribbons.css" rel="stylesheet">

		<style>
			body
			{
				margin: 25px auto;
				padding: 20px;
				width: 80%;
				height: 1000px;
				background: #fff;
				font-family: 'trebuchet MS', Arial, helvetica;
				color: #ddd;
				-moz-border-radius: 10px;
				border-radius: 10px;        
				-moz-box-shadow: 0 0 10px #555;
				-webkit-box-shadow: 0 0 10px #555;
				box-shadow: 0 0 10px #555;
			}

			.compliancebutton
			{
				background: transparent;
				border: none !important;
			}
		</style>
	</head>
	
	<body id='skin-blur-night' onload="drawnetworkmap()">

		<!-- Notification Panel -->
		<div class='notification-bar'> 
			<div class='notification-text'>
				<center>
					<div class="corner-ribbon top-left sticky blue">Beta</div>
					<h1> Quick Lookup - Server Information </h1>
					$(
						If($($OSInfo."Info Last Updated") -ne $null)
						{
							"Last Updated: $($OSInfo."Info Last Updated".Split(' ')[0])"
						}
					)
				</center>
			</div>
		</div>

		<a class="ViewAll" style="float: left;">Expand All</a>
		<a class="PrintAll" style="float: right;">Print</a>
		
		<!-- Collapse -->
		<div class="block-area" id="collapse">

			<div class="accordion tile">

				$(
					If($OSGeneralInfo -ne $null)
					{
						"<div class='panel panel-default'>"
							"<div class='panel-heading'>"
								"<h3 class='panel-title'>"
									"<a class='accordion-toggle active' data-toggle='collapse' data-parent='#accordion' href='#collapseOS'>Virtual Machine Summary</a>"
								"</h3>"
							"</div>"
							"<div id='collapseOS' class='panel-collapse collapse'>"
								"<div class='panel-body'>"
										
									"<div class='row'>"
										
										"<!--  General OS Info -->"
										"<div class='col-md-4'>"
											"<div class='tile'>"
												"<h2 class='tile-title'>OS General Info</h2>"
												"<div class='tile-config dropdown'>"
													"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
													"<ul class='dropdown-menu pull-right text-right'>"
														"<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>"
													"</ul>"
												"</div>"
											
												"<!-- OS Info -->"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='FQDN' data-content='This property represents the name of the VM as seen by vCenter.'> <font color='green'> <i class='fa fa-check-circle'></i> </font> </button> FQDN: $($OSGeneralInfo.FQDN) </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Domain Suffix' data-content=''> <font color='green'> <i class='fa fa-check-circle'></i> </font> </button> Domain Suffix: $($OSGeneralInfo.'Domain Suffix') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Environment' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Environment: $($OSGeneralInfo.Environment) </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='OS Type' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> OS Type: $($OSGeneralInfo.'OS Type') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='OS Version' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> OS Version: $($OSGeneralInfo.'OS Version') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='OS Edition' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> OS Edition: $($OSGeneralInfo.'OS Edition') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='OS Build' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> OS Build: $($OSGeneralInfo.'OS Build') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='End Of Life Date' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> End Of Life Date: $($OSGeneralInfo.'End Of Life Date') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='End Of Support Date' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> End Of Support Date: $($OSGeneralInfo.'End Of Support Date') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='End OF Extended Support Date' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> End OF Extended Support Date: $($OSGeneralInfo.'End Of Extended Support Date') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Server UUID' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Server UUID: $($OSGeneralInfo.UUID) </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Current Logon Server' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Current Logon Server: </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Firewall Rules' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Firewall Rules: </br>"
												
											"</div>"
										"</div>"

										"<!-- CPU Info -->"
										"<div class='col-md-3'>"
											"<div class='tile'>"
												"<h2 class='tile-title'>CPU / RAM Info</h2>"
												"<div class='tile-config dropdown'>"
													"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
													"<ul class='dropdown-menu pull-right text-right'>"
														"<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>"
													"</ul>"
												"</div>"
												
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='CPU Sockets' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> CPU Sockets: $($OSCPUInfo.'Number of Processors') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Cores Per Socket' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Cores Per Socket: $($OSCPUInfo.'Cores Per Processor') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Total Cores' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Total Cores: $($OSCPUInfo.'Number of Logical Processors') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='CPU Threading Enabled' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> CPU Threading Enabled: $($OSCPUInfo.'CPU Threading Enabled') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Logical RAM' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Logical RAM: $($OSRAMInfo.'Logical RAM') </br>"
												
											"</div>"
										"</div>"
										
										"<!-- Networking Info -->"
										"<div class='col-md-5'>"
											"<div class='tile'>"
												"<h2 class='tile-title'>Networking Info</h2>"
												"<div class='tile-config dropdown'>"
													"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
													"<ul class='dropdown-menu pull-right text-right'>"
														"<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>"
													"</ul>"
												"</div>"
												
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Primary Network Interface Name' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Primary Network Interface Name: $($OSNetworkInfo.'Interface Name') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Primary Network Interface IP Address' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Primary Network Interface IP Address: $($OSNetworkInfo.'IP Address') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Primary Network Interface MAC Address' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Primary Network Interface MAC Address: $($OSNetworkInfo.'MAC Address') </br>"
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Connected Switch Port' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Switch Port: $($OSNetworkInfo.'Connected Switch') </br>"
												
											"</div>"
										"</div>"
										
										"<!-- Disk Info -->"
										"<div class='col-md-8'>"
											"<div class='tile'>"
												"<h2 class='tile-title'>Disk Info</h2>"
												"<div class='tile-config dropdown'>"
													"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
													"<ul class='dropdown-menu pull-right text-right'>"
														"<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>"
													"</ul>"
												"</div>"

													"$DiskArray"

											"</div>"
										"</div>"

										"<!-- User Info -->"
										"<div class='col-md-12'>"
											"<div class='tile'>"
												"<h2 class='tile-title'>User Info</h2>"
												"<div class='tile-config dropdown'>"
													"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
													"<ul class='dropdown-menu pull-right text-right'>"
														"<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>"
													"</ul>"
												"</div>"
												
												"<!-- Current Logged On Users -->"
												"<div class='tile'>"
													"<h2 class='tile-title'><a data-toggle='collapse' data-parent='#accordion2' href='#collapseCurrentUsers'>Current Logged On Users <span style='float: right;'>(Click To Expand)</span></a></h2>"
													
													"<div id='collapseCurrentUsers' class='panel-collapse collapse in'>"
														"<div class='panel-body'>"
														
															"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='All Logged On Users' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Current Logged On Users: </br>"

														"</div>"
													"</div>"
												"</div>"
												
												"<!-- Users Logged On In Last 30 Days -->"
												"<div class='tile' style='margin-top: -15;'>"
													"<h2 class='tile-title'><a data-toggle='collapse' data-parent='#accordion2' href='#collapseOldUsers'>Users Logged On In Last 30 Days <span style='float: right;'>(Click To Expand)</span></a></h2>"
													
													"<div id='collapseOldUsers' class='panel-collapse collapse in'>"
														"<div class='panel-body'>"

															"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='All Logged On Users' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Users Logged On In Last 30 Days: </br>"

														"</div>"
													"</div>"
												"</div>"
											
												"<!-- Failed Login Attempts In Last 30 Days -->"
												"<div class='tile' style='margin-top: -15;'>"
													"<h2 class='tile-title'><a data-toggle='collapse' data-parent='#accordion2' href='#collapseFailedUsers'>Failed Login Attempts In Last 30 Days <span style='float: right;'>(Click To Expand)</span></a></h2>"
													
													"<div id='collapseFailedUsers' class='panel-collapse collapse in'>"
														"<div class='panel-body'>"
														
															"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Failed Logon Attempts Counter And Who' data-content=''><font color='green'><i class='fa fa-check-circle'></i></font></button> Failed Logon Attempts Counter And Who: </br>"
												
														"</div>"
													"</div>"
												"</div>"

											"</div>"
										"</div>"

										"<!-- Share Info -->"
										"<div class='col-md-12'>"
											"<div class='tile'>"
												"<h2 class='tile-title'>Share Info</h2>"
												"<div class='tile-config dropdown'>"
													"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
													"<ul class='dropdown-menu pull-right text-right'>"
														"<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>"
													"</ul>"
												"</div>"

													"$ShareArray"
													
											"</div>"
										"</div>"
	
									"</div>"

									"<!-- Service Ports -->"
									If(($OSPortInfo -ne $null) -AND ($($OSPortInfo.OpenPorts) -ne 'None'))
									{
										"<div class='tile'>"
											"<h2 class='tile-title'><a data-toggle='collapse' data-parent='#accordion2' href='#collapseServicePorts'>Service Ports <span style='float: right;'>(Click To Expand)</span></a></h2>"
											"<div id='collapseServicePorts' class='panel-collapse collapse in'>"
												"<div class='panel-body'>"

													ForEach ($Port in $($OSPortInfo.OpenPorts.Trim('[]').Split(',').TrimStart().TrimEnd() | Sort | Select -Unique))
													{
														"<a href='https://www.grc.com/port_$Port.htm' target='_blank'> $Port </a> &nbsp;"
													}

												"</div>"
											"</div>"
										"</div>"
									}

									"<!-- Patches -->"
									If(($OSPatchInfo -ne $null) -AND ($($OSPatchInfo.Patches) -ne 'None'))
									{
										"<div class='tile'>"
											"<h2 class='tile-title'><a data-toggle='collapse' data-parent='#accordion2' href='#collapsePatches'>Patches / Hotfixes<span style='float: right;'>(Click To Expand)</span></a></h2>"
											"<div id='collapsePatches' class='panel-collapse collapse in'>"
												"<div class='panel-body'>"

													ForEach ($Patch in $($OSPatchInfo.Patches.Trim('[]').Split(',').TrimStart().TrimEnd().Trim("'")))
													{
														"<a href='https://support.microsoft.com/en-us/kb/$($Patch.Trim("KB"))' target='_blank'> $Patch </a> &nbsp;"
													}

												"</div>"
											"</div>"
									}	"</div>"

									"<!-- Services -->"
									If(($OSServiceInfo -ne $null) -AND ($($OSServiceInfo.Services) -ne 'None'))
									{
										"<div class='tile'>"
											"<h2 class='tile-title'><a data-toggle='collapse' data-parent='#accordion2' href='#collapseServices'>Services <span style='float: right;'>(Click To Expand)</span></a></h2>"
											"<div id='collapseServices' class='panel-collapse collapse in'>"
												"<div class='panel-body'>"

													ForEach ($Service in $($OSServiceInfo.Services.Trim('[]').Split(',').TrimStart().TrimEnd().Trim("'") | Sort))
													{
														"$Service <br>"
													}

												"</div>"
											"</div>"
										"</div>"
									}

									"<!-- Installed Software -->"
									If(($OSSoftwareInfo -ne $null) -AND ($($OSSoftwareInfo.IdentifiedSoftware) -ne 'None'))
									{
										"<div class='tile'>"
											"<h2 class='tile-title'><a data-toggle='collapse' data-parent='#accordion2' href='#collapseSoftware'>Installed Software <span style='float: right;'>(Click To Expand)</span></a></h2>"
											"<div id='collapseSoftware' class='panel-collapse collapse in'>"
												"<div class='panel-body'>"

													ForEach ($Software in $($OSSoftwareInfo.IdentifiedSoftware.Trim('[]').Split(',').TrimStart().TrimEnd().Trim("'") | Sort))
													{
														"$Software <br>"
													}
													
												"</div>"
											"</div>"
										"</div>"
									}

								"</div>"
							"</div>"
						"</div>"
					}
				)
					
				<div class="panel panel-default" style='margin-top: -20;'>
					<div class="panel-heading">
						<h3 class="panel-title">
							<a class="accordion-toggle active" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Virtual Machine Compliance Summary</a>
						</h3>
					</div>
					<div id="collapseOne" class="panel-collapse collapse">
						<div class="panel-body">
								
							<div class="row">
								
								<!--  General VM Info -->
								<div class="col-md-4">
									<div class="tile">
										<h2 class="tile-title">General VM Info</h2>
										<div class='tile-config dropdown'>
											<a data-toggle='dropdown' href='' class='tile-menu'></a>
											<ul class='dropdown-menu pull-right text-right'>
												<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>
											</ul>
										</div>
									
										<!-- VM Name Info -->
										<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM vCenter Name' data-content='This property represents the name of the VM as seen by vCenter.'> <font color='green'> <i class='fa fa-check-circle'></i> </font> </button> VM vCenter Name: $Info_VM_vCenter_Name </br>
										<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM Host Name' data-content='This property represents the hostname of the VM as seen by the OS. This property may be blank if the VM has never been started, is currently powered off, or if the OS does not have the hostname configured properly.'> <font color='green'> <i class='fa fa-check-circle'></i> </font> </button> VM Host Name: $Info_VM_Host_Name </br>
										<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM DNS Name' data-content='This property represents the name of the VM as seen by DNS. This property may be blank if the VM has never been started, is currently powered off, or if the host is not registered in DNS.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM DNS Name: $Info_VM_DNS_Name </br>
										
										<!-- VM Version Compliance -->
										$( 
											#Check The VM Hardware Version 
											If($Info_VM_Hardware_Version -ne $null)
											{
												#Normalize The Version
												$VMVersion = $Info_VM_Hardware_Version.Trim('v')

												#Version Was Successfully Parsed And Is Compatible
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM Hardware Version' data-content='This property represents the VM hardware version as seen by vCenter.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM Hardware Version: $VMVersion </br>"
											}
											Else
											{
												#Empty Value Found For Hostname
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' title='Why Did This Check Fail?' data-content='This check most likely failed due to an empty value in the hostname property for the vm. Please verify VMWare tools are installed and the VM is on the network and try again.'><font color='red'><i class='fa fa-times-circle'></i></font></button> VM Hardware Version: $Info_VM_Hardware_Version </br>"
											}		
										)

										<!-- Power State Compliance -->
										$( 
											#Check To See If A Value For Last Modified Was Found
											If($Info_VM_Power_State -eq 'poweredOn')
											{
												#VM Power State Is On
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM Power State' data-content='This property represents the current VM Power State as seen by vCenter.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM Power State: $Info_VM_Power_State </br>"
											}
											Else
											{
												#VM Power State Is Off
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' title='Why Did This Check Fail?' data-content='This check most likely failed due to an empty value in the host name property for the vm. Please verify VMWare tools are installed and the VM is on the network and try again.'><font color='red'><i class='fa fa-times-circle'></i></font></button> VM Power State: $Info_VM_Power_State </br>"
											}		
										)

										<!-- BIOS Firmware -->
										$( 
											#Show The BIOS Firmware Type
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM BIOS Firmware' data-content='This property represents the BIOS emulation mode as configured in vCenter.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM BIOS Firmware: $Info_VM_BIOS_Firmware_Type </br>"
										)
										
										<!-- EVC Mode -->
										$( 
											#Show The Server's EVC Mode
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM EVC Mode' data-content='This property represents the VM EVC mode as it is currently configured in vCenter. This property may not be the same as the hosts EVC mode.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM EVC Mode: $Info_VM_EVC_Mode </br>"
										)
										
										<!-- Fault Tolerance Policy -->
										$( 
											#Show The VM Fault Tolerance Policy
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM Fault Tolerance Policy' data-content='This property represents whether the VM has a fault tolerance enabled set as seen by vCenter. This will only be enabled if there is another VM running in lock-step with this VM.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM Fault Tolerance Policy: $Info_VM_Fault_Tolerance_Policy </br>"
										)

										<!-- VM vCenter Server -->
										$( 
											#Show The vCenter & Friendly Name The Server Currently Resides In 
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM Current Datacenter' data-content='This property represents the current vCenter it is managed by and its friendly name.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM Current Datacenter: $Info_vCenter_Label ($Info_vCenter) </br>"
										)
										
										<!-- VM OS -->
										$( 
											#Check To See If A Value For Last Modified Was Found
											If($Info_VM_OS -eq $Info_VM_Container_OS)
											{
												#VM OS And Container OS Match
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM OS' data-content='This property represent the current VM Guest OS as detected by vCenter.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM OS: $Info_VM_OS </br>"
											}
											Else
											{
												#VM OS And Container OS Do Not Match
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to operating system not being detected, not installed or does not match the container OS.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> VM OS: $Info_VM_OS </br>"
											}		
										)
										
										<!-- VM Container OS -->
										$( 
											#Check To See If A Value For Last Modified Was Found
											If($Info_VM_Container_OS -eq $Info_VM_OS)
											{
												#VM OS And Container OS Match
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='VM Container OS' data-content='This property represents the current OS container as configured in vCenter when the VM container was initially built.'><font color='green'><i class='fa fa-check-circle'></i></font></button> VM Container OS: $Info_VM_Container_OS </br>"
											}
											Else
											{
												#VM OS And Container OS Do Not Match
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to a mismatch with the VM OS.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> VM Container OS: $Info_VM_Container_OS </br>"
											}		
										)
									</div>
								</div>

								<!-- CPU Info -->
								<div class="col-md-4">
									<div class="tile">
										<h2 class="tile-title">VM CPU Info</h2>
										<div class='tile-config dropdown'>
											<a data-toggle='dropdown' href='' class='tile-menu'></a>
											<ul class='dropdown-menu pull-right text-right'>
												<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>
											</ul>
										</div>
										
										<!-- VM CPU Sockets Assigned Compliance -->
										$(
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_Host_CPU_Socket_Count -ge $Info_VM_CPU_Socket_Count)
											{
												#VM CPU Sockets Settings Are Compliant
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> CPU Sockets Assigned: $Info_VM_CPU_Socket_Count </br>"
											}
											Else
											{
												#VM CPU Sockets Settings Are Not Compliant
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> CPU Sockets Assigned: $Info_VM_CPU_Socket_Count (Max Allowed: $Info_Host_CPU_Socket_Count) </br>"
											}		
										)
										
										<!-- VM CPU Cores Per Socket Compliance -->
										$( 
											#Check To See If The VM's Cores Per Socket Count Is Larger Than The Host It Sits On Cores Per Socket Count
											If($Info_Host_CPU_Cores_Per_Socket_Count -ge $Info_VM_CPU_Cores_Per_Socket_Count)
											{
												#VM CPU Cores Per Socket Settings Are Compliant, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> CPU Cores Sockets Assigned: $Info_VM_CPU_Cores_Per_Socket_Count </br>"
											}
											Else
											{
												#VM CPU Cores Per Socket Settings Are Not Compliant, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of cores per socket defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> CPU Cores Sockets Assigned: $Info_VM_CPU_Cores_Per_Socket_Count (Max Allowed: $Info_Host_CPU_Cores_Per_Socket_Count) </br>"
											}		
										)

										<!-- VM CPU Cores Per Socket Compliance -->
										$( 
											#Check To See If The VM's Cores Per Socket Count Is Larger Than The Host It Sits On Cores Per Socket Count
											If($Info_Host_CPU_Total_Cores_Count -ge $Info_VM_CPU_Total_Cores_Count)
											{
												#VM CPU Total Cores Are Within Compliance Limits
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Total vCPU Cores Assigned: $Info_VM_CPU_Total_Cores_Count </br>"
											}
											Else
											{
												#VM CPU Total Cores Are Outside Compliance Limits
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of cores per socket defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> Total vCPU Cores Assigned: $Info_VM_CPU_Total_Cores_Count (Max Allowed: $Info_Host_CPU_Total_Cores_Count) </br>"
											}		
										)

										<!-- VM CPU Hot Add Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_VM_CPU_Hot_Add_Enabled -eq 'True')
											{
												#CPU Hot Add Is Enabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> CPU Hot Add Enabled: $Info_VM_CPU_Hot_Add_Enabled </br>"
											}
											Else
											{
												#CPU Hot Add Is Disabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> CPU Hot Add Enabled: $Info_VM_CPU_Hot_Add_Enabled </br>"
											}		
										)
										
										<!-- VM CPU Hot Remove Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_VM_CPU_Hot_Remove_Enabled -eq 'True')
											{
												#CPU Hot Remove Is Enabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> CPU Hot Remove Enabled: $Info_VM_CPU_Hot_Remove_Enabled </br>"
											}
											Else
											{
												#CPU Hot Remove Is Disabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> CPU Hot Remove Enabled: $Info_VM_CPU_Hot_Remove_Enabled </br>"
											}		
										)
									</div>
								</div>

								<!-- Tools Info -->
								<div class="col-md-4">
									<div class="tile">
										<h2 class="tile-title">VM Tools Info</h2>
										<div class='tile-config dropdown'>
											<a data-toggle='dropdown' href='' class='tile-menu'></a>
											<ul class='dropdown-menu pull-right text-right'>
												<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>
											</ul>
										</div>
										
										<!-- VM Tools Version Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_VM_Tools_Version -ne $null)
											{
												#VM Tools Version Was Found
												#WILL NEED TO WRITE DECODER HERE LATER
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> VMWare Tools Version: $Info_VM_Tools_Version </br>"
											}
											Else
											{
												#VM Tools Version Was Unable To Be Determined
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> VMWare Tools Version: $Info_VM_Tools_Version </br>"
											}		
										)
										
										<!-- VM Tools Version Status Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_VM_Tools_Version_Status -eq 'guestToolsCurrent')
											{
												#CPU Hot Remove Is Enabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> VMWare Tools Version Status: $Info_VM_Tools_Version_Status </br>"
											}
											Else
											{
												#CPU Hot Remove Is Disabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> VMWare Tools Version Status: $Info_VM_Tools_Version_Status </br>"
											}		
										)
										
										<!-- VM Tools Status Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_VM_Tools_Status -eq 'toolsOk')
											{
												#CPU Hot Remove Is Enabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> VMWare Tools Status: $Info_VM_Tools_Status </br>"
											}
											Else
											{
												#CPU Hot Remove Is Disabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> VMWare Tools Status: $Info_VM_Tools_Status </br>"
											}		
										)
										
										<!-- VM Tools Running Status Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_VM_Tools_Running_Status  -eq 'guestToolsRunning')
											{
												#CPU Hot Remove Is Enabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> VMWare Tools Running Status: $Info_VM_Tools_Running_Status  </br>"
											}
											Else
											{
												#CPU Hot Remove Is Disabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> VMWare Tools Running Status: $Info_VM_Tools_Running_Status </br>"
											}		
										)
										
										<!-- VM Tools Upgrade Policy Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than The Host It Sits On Socket Count
											If($Info_VM_Tools_Upgrade_Policy -eq 'upgradeAtPowerCycle')
											{
												#CPU Hot Remove Is Enabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Tools Upgrade Policy: $Info_VM_Tools_Upgrade_Policy </br>"
											}
											Else
											{
												#CPU Hot Remove Is Disabled, Create A Passed Button With Datasource
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> Tools Upgrade Policy: $Info_VM_Tools_Upgrade_Policy </br>"
											}		
										)
									</div>	
								</div>											
								
								<!-- RAM Info -->
								<div class="col-md-4">
									<div class="tile">
										<h2 class="tile-title">VM RAM Info</h2>
										<div class='tile-config dropdown'>
											<a data-toggle='dropdown' href='' class='tile-menu'></a>
											<ul class='dropdown-menu pull-right text-right'>
												<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>
											</ul>
										</div>

										<!-- VM Total Memory Compliance -->
										$( 
											#Check To See If The VM's Socket Count Is Larger Than Than The Host It Sits On
											If($Info_Host_RAM_Total_GB -ge $($Info_VM_Memory_Total_MB / 1024))
											{
												#VM Memory Is Within Compliance Limits
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Memory: $Info_VM_Memory_Total_MB MB </br>"
											}
											Else
											{
												#VM Memory Is Outside Compliance Limits
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> Memory: $Info_VM_Memory_Total_MB MB (Max Allowed: Memory: $Info_Host_RAM_Total_GB GB) </br>"
											}		
										)
										
										<!-- Memory Overhead -->
										$( 
											#Show The Memory Overhead For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Memory Overhead: $([math]::round($($Info_VM_Memory_Overhead_MB)/ 1024 / 1024, 2)) MB </br>"
										)
										
										<!-- VM Memory Hot Add Compliance -->
										$( 
											#Check To See If The VM's Memory Hot Add Feature Is On
											If($Info_VM_Memory_Hot_Add_Enabled -eq 'True')
											{
												#Memory Hot Add Is Enabled
												"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Memory Hot Add Enabled: $Info_VM_Memory_Hot_Add_Enabled </br>"
											}
											Else
											{
												#Memory Hot Add Is Disabled
												"<button class='btn btn-sm pover btn-small compliancebutton' data-trigger='hover' data-toggle='popover' data-placement='top' data-content='This check most likely failed due to the numbers of sockets defined in the VM CPU policy is larger than the number of host sockets available. Please adjust the VM CPU settings to the hosts CPU constraints.' title='Why Did This Check Fail?'><font color='red'><i class='fa fa-times-circle'></i></font></button> Memory Hot Add Enabled: $Info_VM_Memory_Hot_Add_Enabled </br>"
											}		
										)

										<!-- Memory Hot Plug Limit -->
										$( 
											#Show The Memory Hot Plug Limit For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Hot Plug Memory Limit: $Info_VM_Memory_Hot_Plug_Limit_MB MB </br>"
										)
									</div>
								</div>
								
								<!-- Networking Info -->
								<div class="col-md-4">
									<div class="tile">
										<h2 class="tile-title">VM Networking Info</h2>
										<div class='tile-config dropdown'>
											<a data-toggle='dropdown' href='' class='tile-menu'></a>
											<ul class='dropdown-menu pull-right text-right'>
												<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>
											</ul>
										</div>
										
										<!-- IP Addresses -->
										$( 
											#Show The IP Addresses For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> IP Address: $Info_VM_IP_Address </br>"
										)
										
										<!-- NIC Types -->
										$( 
											#Show The NIC Types For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> NIC Types: $Info_VM_NIC_Type </br>"
										)

										<!-- Connection States -->
										$( 
											#Show The Connection States For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Connection States: $Info_VM_Connection_State </br>"
										)
										
										<!-- MAC Addresses -->
										$( 
											#Show The MAC Addresses For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> MAC Addresses: $Info_VM_MAC_Address </br>"
										)
										
										<!-- Port Groups -->
										$( 
											#Show The Port Groups For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> Port Groups: $Info_VM_Port_Group </br>"
										)
										
										<!-- PG VLAN -->
										$( 
											#Show The PG VLANS For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' title='Source: vCenter Property'><font color='green'><i class='fa fa-check-circle'></i></font></button> VLANS: $Info_VM_VLAN </br>"
										)
										
									</div>
								</div>
								
								<!-- Storage Info -->
								<div class="col-md-4">
									<div class="tile">
										<h2 class="tile-title">VM Storage Info</h2>
										<div class='tile-config dropdown'>
											<a data-toggle='dropdown' href='' class='tile-menu'></a>
											<ul class='dropdown-menu pull-right text-right'>
												<li><a class='tile-info-toggle' href=''>Where Does This Info Come From?</a></li>
											</ul>
										</div>
										
										<!-- Swap File Policy -->
										$( 
											#Show The Swap File Policy For The Current VM
											"<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' ><font color='green'><i class='fa fa-check-circle'></i></font></button> VM Swap File Policy: $Info_VM_Swap_File_Policy </br>"
										)
										
										<!-- VM Datastores Info -->
										<button class='btn btn-sm pover btn-small compliancebutton' data-toggle='popover' data-placement='top' ><font color='green'><i class='fa fa-check-circle'></i></font></button> Datastores: $Info_VM_Datastore_List </br>

										<!-- VM Snapshots Info -->

											<div class="tile" style='margin-top: 15;'>
												<h2 class="tile-title"><a data-toggle="collapse" data-parent="#accordion2" href="#collapseSnapshots">SNAPSHOTS <span style='float: right;'>(Click To Expand)</span></a></h2>
												
												<div id="collapseSnapshots" class="panel-collapse collapse in">
													<div class="panel-body">
													$(
														If($Info_VM_Snapshot_List -ne $null)
														{
															$Snapshot_List = $Info_VM_Snapshot_List.Split(',')
															
															ForEach($Snap in $Snapshot_List)
															{
																"$Snap <br>"
															}
														}
													)
													</div>
												</div>
											</div>

									</div>
								</div>

							</div>

							<!-- Recent VM Tasks -->
							<div class="tile">
								<h2 class="tile-title"><a data-toggle="collapse" data-parent="#accordion2" href="#collapseTasks">RECENT TASKS  <span style='float: right;'>(Click To Expand)</span></a></h2>
							</div>	
							<div id="collapseTasks" class="panel-collapse collapse in">
								<div class="panel-body">
								$(
									If($Info_VM_Task_List -ne $null)
									{
										$Task_List = $Info_VM_Task_List.Split(',')
										
										ForEach($Task in $Task_List)
										{
											"$Task <br>"
										}
									}
								)
								</div>
							</div>

						</div>
					</div>
				</div>				

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">Performance Charts / Graphs / Maps</a>
						</h3>
					</div>
					<div id="collapseTwo" class="panel-collapse collapse in">
						<div class="panel-body">

							<!-- CPU Ready Chart -->
							$(

								#Turn On/Off Stat Charts Based On Results From Stats
								If($($Info_VM_CPU_Ready_Stats.Count) -ne 1)
								{
									"<div class='tile'>"
									"<h2 class='tile-title'>NO DATA FOUND FOR CPU Ready - Last 10 Days (ms)</h2>"
									"</div>"
								}
								Else
								{
									"<div class='tile'>"
										"<h2 class='tile-title'>CPU Ready - Last 10 Days (ms)</h2>"
										"<div class='tile-config dropdown'>"
											"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
											"<ul class='dropdown-menu pull-right text-right'>"
												"<li><a class='tile-info-toggle' href=''>Chart Information</a></li>"
											"</ul>"
										"</div>"
										"<div class='p-10'>"
											"<div id='cpu-ready-chart' class='main-chart' style='height: 250px'></div>"
										"</div>"
									"</div>"
								}
							)

							<!-- CPU Usage Chart -->
							$(

								#Turn On/Off Stat Charts Based On Results From Stats
								If($($Info_VM_CPU_Stats.Count) -ne 1)
								{
									"<div class='tile'>"
									"<h2 class='tile-title'>NO DATA FOUND FOR CPU Usage - Last 10 Days (%)</h2>"
									"</div>"
								}
								Else
								{
									"<div class='tile'>"
										"<h2 class='tile-title'>CPU Usage - Last 10 Days (%)</h2>"
										"<div class='tile-config dropdown'>"
											"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
											"<ul class='dropdown-menu pull-right text-right'>"
												"<li><a class='tile-info-toggle' href=''>Chart Information</a></li>"
											"</ul>"
										"</div>"
										"<div class='p-10'>"
											"<div id='cpu-chart' class='main-chart' style='height: 250px'></div>"
										"</div>"
									"</div>"
								}
							)
							
							<!-- Memory Usage Chart -->
							$(

								#Turn On/Off Stat Charts Based On Results From Stats
								If($($Info_VM_RAM_Stats.Count) -ne 1)
								{
									"<div class='tile'>"
									"<h2 class='tile-title'>NO DATA FOUND FOR RAM Usage - Last 10 Days (%)</h2>"
									"</div>"
								}
								Else
								{
									"<div class='tile'>"
										"<h2 class='tile-title'>RAM Usage - Last 10 Days (%)</h2>"
										"<div class='tile-config dropdown'>"
											"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
											"<ul class='dropdown-menu pull-right text-right'>"
												"<li><a class='tile-info-toggle' href=''>Chart Information</a></li>"
											"</ul>"
										"</div>"
										"<div class='p-10'>"
											"<div id='ram-chart' class='main-chart' style='height: 250px'></div>"
										"</div>"
									"</div>"
								}
							)
							
							<!-- Disk Usage Chart -->
							$(

								#Turn On/Off Stat Charts Based On Results From Stats
								If($($Info_VM_Disk_Stats.Count) -ne 1)
								{
									"<div class='tile'>"
									"<h2 class='tile-title'>NO DATA FOUND FOR Disk Usage - Last 10 Days (KBps)</h2>"
									"</div>"
								}
								Else
								{
									"<div class='tile'>"
										"<h2 class='tile-title'>DISK Usage - Last 10 Days (KBps)</h2>"
										"<div class='tile-config dropdown'>"
											"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
											"<ul class='dropdown-menu pull-right text-right'>"
												"<li><a class='tile-info-toggle' href=''>Chart Information</a></li>"
											"</ul>"
										"</div>"
										"<div class='p-10'>"
											"<div id='disk-chart' class='main-chart' style='height: 250px'></div>"
										"</div>"
									"</div>"
								}
							)
							
							<!-- Network Usage Chart -->
							$(

								#Turn On/Off Stat Charts Based On Results From Stats
								If($($Info_VM_Net_Stats.Count) -ne 1)
								{
									"<div class='tile'>"
									"<h2 class='tile-title'>NO DATA FOUND FOR NET Usage - Last 10 Days (Mbps)</h2>"
									"</div>"
								}
								Else
								{
									"<div class='tile'>"
										"<h2 class='tile-title'>NET Usage - Last 10 Days (Mbps)</h2>"
										"<div class='tile-config dropdown'>"
											"<a data-toggle='dropdown' href='' class='tile-menu'></a>"
											"<ul class='dropdown-menu pull-right text-right'>"
												"<li><a class='tile-info-toggle' href=''>Chart Information</a></li>"
											"</ul>"
										"</div>"
										"<div class='p-10'>"
											"<div id='net-chart' class='main-chart' style='height: 250px'></div>"
										"</div>"
									"</div>"
								}
							)
						</div>
					</div>
				</div>
				
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Links And Resources</a>
						</h3>
					</div>
					<div id="collapseThree" class="panel-collapse collapse in">
						<div class="panel-body">
							NO EXTERNAL LINKS FOUND!
						</div>
					</div>
				</div>
			</div>
		</div>
	
		<!-- jQuery -->
		<script src="js/jquery.min.js"></script> <!-- jQuery Library -->
		<script src="js/jquery-ui.min.js"></script> <!-- jQuery UI -->
		<script src="js/jquery.easing.1.3.js"></script> <!-- jQuery Easing - Requirred for Lightbox + Pie Charts-->

		<!-- Bootstrap -->
		<script src="js/bootstrap.min.js"></script>
		
		<!-- Charts -->
		<script src="js/charts/jquery.flot.js"></script> <!-- Flot Main -->
		<script src="js/charts/jquery.flot.time.js"></script> <!-- Flot sub -->
		<script src="js/charts/jquery.flot.animator.min.js"></script> <!-- Flot sub -->
		<script src="js/charts/jquery.flot.resize.min.js"></script> <!-- Flot sub - for repaint when resizing the screen -->

		<script src="js/sparkline.min.js"></script> <!-- Sparkline - Tiny charts -->
		<script src="js/easypiechart.js"></script> <!-- EasyPieChart - Animated Pie Charts -->

		<!-- All JS functions -->
		<script src="js/functions.js"></script>
		
		<!-- CPU Ready Chart Data -->
		<script>
			`$(function () {
				if (`$('#cpu-ready-chart')[0]) {
					
					$(
						#Turn Chart On Or Off Based On Stats
						If($Info_VM_CPU_Ready_Stats -eq $null)
						{
							"var cr1 = [ [1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9], [10,10] ];"
						}
						Else
						{
							"var cr1 = [[1,$($Info_VM_CPU_Ready_Stats.Split(',')[0])], [2,$($Info_VM_CPU_Ready_Stats.Split(',')[1])], [3,$($Info_VM_CPU_Ready_Stats.Split(',')[2])], [4,$($Info_VM_CPU_Ready_Stats.Split(',')[3])], [5,$($Info_VM_CPU_Ready_Stats.Split(',')[4])], [6,$($Info_VM_CPU_Ready_Stats.Split(',')[5])], [7,$($Info_VM_CPU_Ready_Stats.Split(',')[6])], [8,$($Info_VM_CPU_Ready_Stats.Split(',')[7])], [9,$($Info_VM_CPU_Ready_Stats.Split(',')[8])], [10,$($Info_VM_CPU_Ready_Stats.Split(',')[9])]];"
						}
					)
						
					`$.plot('#cpu-ready-chart', [ {
						data: cr1,
						label: "Data",

					},],

						{
							series: {
								lines: {
									show: true,
									lineWidth: 1,
									fill: 0.25,
								},

								color: 'rgba(255,255,255,0.7)',
								shadowSize: 0,
								points: {
									show: true,
								}
							},

							yaxis: {
								min: 0,
								tickColor: 'rgba(255,255,255,0.15)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								},
								shadowSize: 0,
							},
							xaxis: {
								tickColor: 'rgba(255,255,255,0)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								}
							},
							grid: {
								borderWidth: 1,
								borderColor: 'rgba(255,255,255,0.25)',
								labelMargin:10,
								hoverable: true,
								clickable: true,
								mouseActiveRadius:6,
							},
							legend: {
								show: false
							}
						});

					`$("#cpu-ready-chart").bind("plothover", function (event, pos, item) {
						if (item) {
							var x = item.datapoint[0].toFixed(2),
								y = item.datapoint[1].toFixed(2);
							`$("#cpu-ready-tooltip").html(item.series.label + " of " + x + " = " + y).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
						}
						else {
							`$("#cpu-ready-tooltip").hide();
						}
					});

					`$("<div id='cpu-ready-tooltip' class='chart-tooltip'></div>").appendTo("body");
				}

			});
		</script>
		
		<!-- CPU Usage Chart Data -->
		<script>
			`$(function () {
				if (`$('#cpu-chart')[0]) {
					
					$(
						#Turn Chart On Or Off Based On Stats
						If($Info_VM_CPU_Stats -eq $null)
						{
							"var c1 = [ [1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9], [10,10] ];"
						}
						Else
						{
							"var c1 = [[1,$($Info_VM_CPU_Stats.Split(',')[0])], [2,$($Info_VM_CPU_Stats.Split(',')[1])], [3,$($Info_VM_CPU_Stats.Split(',')[2])], [4,$($Info_VM_CPU_Stats.Split(',')[3])], [5,$($Info_VM_CPU_Stats.Split(',')[4])], [6,$($Info_VM_CPU_Stats.Split(',')[5])], [7,$($Info_VM_CPU_Stats.Split(',')[6])], [8,$($Info_VM_CPU_Stats.Split(',')[7])], [9,$($Info_VM_CPU_Stats.Split(',')[8])], [10,$($Info_VM_CPU_Stats.Split(',')[9])]];"
						}
					)
						
					`$.plot('#cpu-chart', [ {
						data: c1,
						label: "Data",

					},],

						{
							series: {
								lines: {
									show: true,
									lineWidth: 1,
									fill: 0.25,
								},

								color: 'rgba(255,255,255,0.7)',
								shadowSize: 0,
								points: {
									show: true,
								}
							},

							yaxis: {
								min: 0,
								tickColor: 'rgba(255,255,255,0.15)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								},
								shadowSize: 0,
							},
							xaxis: {
								tickColor: 'rgba(255,255,255,0)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								}
							},
							grid: {
								borderWidth: 1,
								borderColor: 'rgba(255,255,255,0.25)',
								labelMargin:10,
								hoverable: true,
								clickable: true,
								mouseActiveRadius:6,
							},
							legend: {
								show: false
							}
						});

					`$("#cpu-chart").bind("plothover", function (event, pos, item) {
						if (item) {
							var x = item.datapoint[0].toFixed(2),
								y = item.datapoint[1].toFixed(2);
							`$("#cpu-tooltip").html(item.series.label + " of " + x + " = " + y).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
						}
						else {
							`$("#cpu-tooltip").hide();
						}
					});

					`$("<div id='cpu-tooltip' class='chart-tooltip'></div>").appendTo("body");
				}

			});
		</script>
		
		<!-- RAM Usage Chart Data -->
		<script>
			`$(function () {
				if (`$('#ram-chart')[0]) {
					
					$(
						#Turn Chart On Or Off Based On Stats
						If($Info_VM_RAM_Stats -eq $null)
						{
							"var r1 = [ [1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9], [10,10] ];"
						}
						Else
						{
							"var r1 = [[1,$($Info_VM_RAM_Stats.Split(',')[0])], [2,$($Info_VM_RAM_Stats.Split(',')[1])], [3,$($Info_VM_RAM_Stats.Split(',')[2])], [4,$($Info_VM_RAM_Stats.Split(',')[3])], [5,$($Info_VM_RAM_Stats.Split(',')[4])], [6,$($Info_VM_RAM_Stats.Split(',')[5])], [7,$($Info_VM_RAM_Stats.Split(',')[6])], [8,$($Info_VM_RAM_Stats.Split(',')[7])], [9,$($Info_VM_RAM_Stats.Split(',')[8])], [10,$($Info_VM_RAM_Stats.Split(',')[9])]];"
						}
					)

					`$.plot('#ram-chart', [ {
						data: r1,
						label: "Data",

					},],

						{
							series: {
								lines: {
									show: true,
									lineWidth: 1,
									fill: 0.25,
								},

								color: 'rgba(255,255,255,0.7)',
								shadowSize: 0,
								points: {
									show: true,
								}
							},

							yaxis: {
								min: 0,
								tickColor: 'rgba(255,255,255,0.15)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								},
								shadowSize: 0,
							},
							xaxis: {
								tickColor: 'rgba(255,255,255,0)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								}
							},
							grid: {
								borderWidth: 1,
								borderColor: 'rgba(255,255,255,0.25)',
								labelMargin:10,
								hoverable: true,
								clickable: true,
								mouseActiveRadius:6,
							},
							legend: {
								show: false
							}
						});

					`$("#ram-chart").bind("plothover", function (event, pos, item) {
						if (item) {
							var x = item.datapoint[0].toFixed(2),
								y = item.datapoint[1].toFixed(2);
							`$("#ram-tooltip").html(item.series.label + " of " + x + " = " + y).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
						}
						else {
							`$("#ram-tooltip").hide();
						}
					});

					`$("<div id='ram-tooltip' class='chart-tooltip'></div>").appendTo("body");
				}

			});
		</script>
		
		<!-- Disk Usage Chart Data -->
		<script>
			`$(function () {
				if (`$('#disk-chart')[0]) {
					
					$(
						#Turn Chart On Or Off Based On Stats
						If($Info_VM_Disk_Stats -eq $null)
						{
							"var d1 = [[1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9], [10,10]];"
						}
						Else
						{
							"var d1 = [[1,$($Info_VM_DISK_Stats.Split(',')[0])], [2,$($Info_VM_DISK_Stats.Split(',')[1])], [3,$($Info_VM_DISK_Stats.Split(',')[2])], [4,$($Info_VM_DISK_Stats.Split(',')[3])], [5,$($Info_VM_DISK_Stats.Split(',')[4])], [6,$($Info_VM_DISK_Stats.Split(',')[5])], [7,$($Info_VM_DISK_Stats.Split(',')[6])], [8,$($Info_VM_DISK_Stats.Split(',')[7])], [9,$($Info_VM_DISK_Stats.Split(',')[8])], [10,$($Info_VM_DISK_Stats.Split(',')[9])]];"
						}
					)

					`$.plot('#disk-chart', [ {
						data: d1,
						label: "Data",

					},],

						{
							series: {
								lines: {
									show: true,
									lineWidth: 1,
									fill: 0.25,
								},

								color: 'rgba(255,255,255,0.7)',
								shadowSize: 0,
								points: {
									show: true,
								}
							},

							yaxis: {
								min: 0,
								tickColor: 'rgba(255,255,255,0.15)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								},
								shadowSize: 0,
							},
							xaxis: {
								tickColor: 'rgba(255,255,255,0)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								}
							},
							grid: {
								borderWidth: 1,
								borderColor: 'rgba(255,255,255,0.25)',
								labelMargin:10,
								hoverable: true,
								clickable: true,
								mouseActiveRadius:6,
							},
							legend: {
								show: false
							}
						});

					`$("#disk-chart").bind("plothover", function (event, pos, item) {
						if (item) {
							var x = item.datapoint[0].toFixed(2),
								y = item.datapoint[1].toFixed(2);
							`$("#disk-tooltip").html(item.series.label + " of " + x + " = " + y).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
						}
						else {
							`$("#disk-tooltip").hide();
						}
					});

					`$("<div id='disk-tooltip' class='chart-tooltip'></div>").appendTo("body");
				}

			});
		</script>
		
		<!-- Network Usage Chart Data -->
		<script>
			`$(function () {
				if (`$('#net-chart')[0]) {
					
					$(
						#Turn Chart On Or Off Based On Stats
						If($Info_VM_Net_Stats -eq $null)
						{
							"var n1 = [[1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9], [10,10]];"
						}
						Else
						{
							"var n1 = [[1,$($Info_VM_NET_Stats.Split(',')[0])], [2,$($Info_VM_NET_Stats.Split(',')[1])], [3,$($Info_VM_NET_Stats.Split(',')[2])], [4,$($Info_VM_NET_Stats.Split(',')[3])], [5,$($Info_VM_NET_Stats.Split(',')[4])], [6,$($Info_VM_NET_Stats.Split(',')[5])], [7,$($Info_VM_NET_Stats.Split(',')[6])], [8,$($Info_VM_NET_Stats.Split(',')[7])], [9,$($Info_VM_NET_Stats.Split(',')[8])], [10,$($Info_VM_NET_Stats.Split(',')[9])]];"
						}
					)

					`$.plot('#net-chart', [ {
						data: n1,
						label: "Data",

					},],

						{
							series: {
								lines: {
									show: true,
									lineWidth: 1,
									fill: 0.25,
								},

								color: 'rgba(255,255,255,0.7)',
								shadowSize: 0,
								points: {
									show: true,
								}
							},

							yaxis: {
								min: 0,
								tickColor: 'rgba(255,255,255,0.15)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								},
								shadowSize: 0,
							},
							xaxis: {
								tickColor: 'rgba(255,255,255,0)',
								tickDecimals: 0,
								font :{
									lineHeight: 13,
									style: "normal",
									color: "rgba(255,255,255,0.8)",
								}
							},
							grid: {
								borderWidth: 1,
								borderColor: 'rgba(255,255,255,0.25)',
								labelMargin:10,
								hoverable: true,
								clickable: true,
								mouseActiveRadius:6,
							},
							legend: {
								show: false
							}
						});

					`$("#net-chart").bind("plothover", function (event, pos, item) {
						if (item) {
							var x = item.datapoint[0].toFixed(2),
								y = item.datapoint[1].toFixed(2);
							`$("#net-tooltip").html(item.series.label + " of " + x + " = " + y).css({top: item.pageY+5, left: item.pageX+5}).fadeIn(200);
						}
						else {
							`$("#net-tooltip").hide();
						}
					});

					`$("<div id='net-tooltip' class='chart-tooltip'></div>").appendTo("body");
				}

			});
		</script>

	</body>
	
</html>
"@
}
Else
{
@" 
<html>
	
	<head>
	
	    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
        <meta name="format-detection" content="telephone=no">
        <meta charset="UTF-8">

        <title>Server Information</title>

        <!-- CSS -->
		<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
		<link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
		<link href="css/ribbons.css" rel="stylesheet">

		<style>
			body
			{
				margin: 25px auto;
				padding: 20px;
				width: 80%;
				height: 1000px;
				background: #fff;
				font-family: 'trebuchet MS', Arial, helvetica;
				color: #ddd;
				-moz-border-radius: 10px;
				border-radius: 10px;        
				-moz-box-shadow: 0 0 10px #555;
				-webkit-box-shadow: 0 0 10px #555;
				box-shadow: 0 0 10px #555;
			}

			button
			{
				background: transparent;
				border: none !important;
				padding-left: 10px;
				padding-right: 10px;
			}
		</style>
	</head>
	
	<body id='skin-blur-night'>
	
		<!-- Notification Panel -->
		<div class='notification-bar'> 
			<div class='notification-text'>
				<center>
					<h1>Quick Lookup - Server Information</h1>
					<div class="corner-ribbon top-left sticky blue">Beta</div>
					<h1>The Server "$($ServerName)" Was Not Found!</h1>
					<h1> <a href="#"> Click Here To Notify Someone If This Server Actually Exists. </a></h1>
				</center>
			</div>
		</div>

		<!-- jQuery -->
        <script src="js/jquery.min.js"></script> <!-- jQuery Library -->
        <script src="js/jquery-ui.min.js"></script> <!-- jQuery UI -->
        <script src="js/jquery.easing.1.3.js"></script> <!-- jQuery Easing - Requirred for Lightbox + Pie Charts-->

        <!-- Bootstrap -->
        <script src="js/bootstrap.min.js"></script>
		
	</body>
	
</html>
"@
}
