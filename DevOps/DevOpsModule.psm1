#Done
function Get-VSTSProjects
{
	<#
	.SYNOPSIS
		Retrieves All VSTS Projects From A Specified VSTS Tenant.
	.DESCRIPTION
		Retrieves all VSTS projects available to a personal access token for a given VSTS tenant.
	.EXAMPLE
		Get-VSTSProjects -VSTS_Instance "sample" -VSTS_UserName "fakeuser" -VSTS_PersonalAccessToken "thepattoken"
		
		id         : b38014aa-0e6d-4d1a-b37c-d6fbf2f17e35
		name       : SampleProj
		url        : https://sample.visualstudio.com/DefaultCollection/_apis/projects/b38014aa-0e6d-4d1a-b37c-d6fbf2f17e35
		state      : wellFormed
		revision   : 119
		visibility : private

	.EXAMPLE
		Get-VSTSProjects -Count
	.PARAMETER VSTS_InstanceName
		The prefix used to define the VSTS instance name. For example, sean.visualstudio.com, your instance name would be "sean".
	.PARAMETER VSTS_Username
		The username the Personal Access Token belongs to.
	.PARAMETER VSTS_PersonalAccessToken
		Your personal Access Token. To setup a PAT, refer to this article: http://blogs.msdn.com/b/buckh/archive/2013/01/07/how-to-connect-to-tf-service-without-a-prompt-for-liveid-credentials.aspx
		You can also go to the PAT direct link: https://yourtenantname.visualstudio.com/_details/security/tokens/Edit
	.PARAMETER MaxProjectsToShow
		Max amount of projects that should be returned. The maximum amount of projects that can be returned is 100.
	.PARAMETER Count
		Using this switch will return the total count of projects for the VSTS tenant (up to 100).
	#>
  
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$True, HelpMessage='Name of the VSTS Instance?')]
		[string]$VSTS_InstanceName,

		[Parameter(Mandatory=$True, HelpMessage='VSTS Tenant Login Username?')]
		[string]$VSTS_UserName,

		[Parameter(Mandatory=$True, HelpMessage='Personal Access Token')]
		[string]$VSTS_PersonalAccessToken,

		[Parameter(HelpMessage='Max Amount Of Projects To Return?')]
		[ValidateRange(1,100)]
		[int]$MaxProjectsToShow = "100",

		[switch]$Count
	)

	#Set API Version
	$APIVersion = "2.0"

	#Build VSTS Base Link
	$VSTS_URL = 'https://' + $VSTS_InstanceName + '.visualstudio.com/DefaultCollection' #Base url for all of the VSO API calls 

	#Base64 Encode The Personal Access Token (PAT)
	$VSTS_EncodedPersonalAccessToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $VSTS_UserName,$VSTS_PersonalAccessToken)))

	#Setup Headers
	$Headers = @{Authorization=("Basic {0}" -f $VSTS_EncodedPersonalAccessToken)}

	#Build Request URI
	$RequestURI = $VSTS_URL + "/_apis/projects?api-version=" + $APIVersion + "&`$top=$MaxProjectsToShow"
	
	#Get Team Project Lists
	try
	{
		$AllProjects = Invoke-RestMethod -Uri $RequestURI -Headers $Headers -Method Get
		
		#Return Project Results
		If($Count)
		{
			return $($AllProjects.Count)
		}
		Else
		{	
			If($($AllProjects.Count) -gt 0)
			{
				return $($AllProjects.Value)
			}
			Else
			{
				return "No Projects Were Found For The Specified Account and Token."
			}
		}
	}
	catch
	{
		throw "Unable To Get Project List.`n$Error[0].Exception"
	}
}

#Done
function Get-VSTSRepositoryList
{
	<#
	.SYNOPSIS
		Retrieves All VSTS Repositories From A Specified VSTS Tenant.
	.DESCRIPTION
		Retrieves all VSTS projects available to a personal access token for a given VSTS tenant.
	.EXAMPLE
		Get-VSTSProjects -VSTS_Instance "sample" -VSTS_UserName "fakeuser" -VSTS_PersonalAccessToken "thepattoken"
		
		id         : b38014aa-0e6d-4d1a-b37c-d6fbf2f17e35
		name       : SampleProj
		url        : https://sample.visualstudio.com/DefaultCollection/_apis/projects/b38014aa-0e6d-4d1a-b37c-d6fbf2f17e35
		state      : wellFormed
		revision   : 119
		visibility : private

	.EXAMPLE
		Get-VSTSProjects -Count
	.PARAMETER VSTS_InstanceName
		The prefix used to define the VSTS instance name. For example, sean.visualstudio.com, your instance name would be "sean".
	.PARAMETER VSTS_Username
		The username the Personal Access Token belongs to.
	.PARAMETER VSTS_PersonalAccessToken
		Your personal Access Token. To setup a PAT, refer to this article: http://blogs.msdn.com/b/buckh/archive/2013/01/07/how-to-connect-to-tf-service-without-a-prompt-for-liveid-credentials.aspx
		You can also go to the PAT direct link: https://yourtenantname.visualstudio.com/_details/security/tokens/Edit
	.PARAMETER Count
		Using this switch will return the total count of repositories for the VSTS instance.
	#>
  
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$True, HelpMessage='Name of the VSTS Instance?')]
		[string]$VSTS_InstanceName,

		[Parameter(Mandatory=$True, HelpMessage='VSTS Tenant Login Username?')]
		[string]$VSTS_UserName,

		[Parameter(Mandatory=$True, HelpMessage='Personal Access Token')]
		[string]$VSTS_PersonalAccessToken,
		
		[switch]$Count
	)

	#Set API Version
	$APIVersion = "1.0"

	#Build VSTS Base Link
	$VSTS_URL = 'https://' + $VSTS_InstanceName + '.visualstudio.com/DefaultCollection' #Base url for all of the VSO API calls 

	#Base64 Encode The Personal Access Token (PAT)
	$VSTS_EncodedPersonalAccessToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $VSTS_UserName,$VSTS_PersonalAccessToken)))

	#Setup Headers
	$Headers = @{Authorization=("Basic {0}" -f $VSTS_EncodedPersonalAccessToken)}

	#Build Request URI
	$RequestURI = $VSTS_URL + "/_apis/git/repositories?api-version=" + $APIVersion

	try
	{
		#Get Repository List
		$RepositoryList = Invoke-RestMethod -Uri $RequestURI -Headers $Headers -Method Get
		
		#Return Respository List Results
		If($Count)
		{
			return $($RepositoryList.Count)
		}
		Else
		{	
			If($($RepositoryList.Count) -gt 0)
			{
				return $($RepositoryList.Value)
			}
			Else
			{
				return "No Projects Were Found For The Specified Account and Token."
			}
		}
	}
	catch
	{
		throw "Unable To Get Repository List.`n$Error[0].Exception"
	}
}

#Done
function New-VSTSProject
{
		<#
	.SYNOPSIS
		Creates a new VSTS project.
	.DESCRIPTION
		Creates a new VSTS project, must be authorized for the given VSTS tenant.
	.EXAMPLE
		Create-VSTSProjects -VSTS_InstanceName "tenantname" -VSTS_Username "username" -PersonalAccessToken "yourtoken" -VSTS_ProjectName "newprojectname"
	.PARAMETER VSTS_InstanceName
		The prefix used to define the VSTS tenant name. For example, sean.visualstudio.com, your tenant name would be "sean".
	.PARAMETER VSTS_Username
		The username the Personal Access Token belongs to.
	.PARAMETER VSTS_PersonalAccessToken
		Your personal Access Token. To setup a PAT, refer to this article: http://blogs.msdn.com/b/buckh/archive/2013/01/07/how-to-connect-to-tf-service-without-a-prompt-for-liveid-credentials.aspx
		You can also go to the PAT direct link: https://yourtenantname.visualstudio.com/_details/security/tokens/Edit
	.PARAMETER VSTS_ProjectName
		Name of new project you want to create in VSTS.
	.PARAMETER VSTS_ProjectDescription
		Description of VSTS project.
	.PARAMETER VSTS_SourceControl
		Description of source control technology. Valid options are Git or TFVS. Default is Git.
	.PARAMETER VSTS_ProcessType
		Define the type of project template. Valid options are Scrum, Agile, CMMI. Scrum is default.
	#>
  
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$False, HelpMessage='Name of the VSTS Tenant?')]
		[string]$VSTS_InstanceName  = "imseandavis",

		[Parameter(Mandatory=$False, HelpMessage='VSTS Tenant Login Username?')]
		[string]$VSTS_UserName = "imseandavis",

		[Parameter(Mandatory=$False, HelpMessage='Personal Access Token')]
		[string]$VSTS_PersonalAccessToken = "mk6ealrn3mbq4fr37zjs2pksqftpm4aeajuxpzanwaxwejc7n5oa",

		[Parameter(
			Mandatory=$True,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='New Project Name?'
		)]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_ProjectName = "",
	
		[Parameter(
			Mandatory=$False,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='New Project Description?'
		)]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_ProjectDescription = "",
		
		[Parameter(
			Mandatory=$True,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='New Project Source Control Type?'
		)]
		[ValidateSet('Git', 'TFVC')]
		$VSTS_SourceControl = "Git",
		
		[Parameter(
			Mandatory=$True,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True,
			HelpMessage='New Project Source Control Type?'
		)]
		[ValidateSet('Scrum', 'CMMI', 'Agile')]
		$VSTS_ProcessType = "Scrum"
	)

	#Set API Version
	$APIVersion = "2.0"

	#Build VSTS Base Link
	$VSTS_URL = 'https://' + $VSTS_InstanceName + '.visualstudio.com/DefaultCollection' #Base url for all of the VSO API calls 

	#Base64 Encode The Personal Access Token (PAT)
	$VSTS_EncodedPersonalAccessToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $VSTS_UserName,$VSTS_PersonalAccessToken)))

	#Setup Headers
	$Headers = @{Authorization=("Basic {0}" -f $VSTS_EncodedPersonalAccessToken)}

	#Decode VSTS Process Type
	switch ($VSTS_ProcessType)
	{
		"Scrum" {$VSTS_ProcessID = "6b724908-ef14-45cf-84f8-768b5384da45"}
		"CMMOI" {$VSTS_ProcessID = "27450541-8e31-4150-9947-dc59f998fc01"}
		"Agile" {$VSTS_ProcessID = "adcc42ab-9882-485e-a3ed-7678f01f66bc"}
		default {$VSTS_ProcessID = "6b724908-ef14-45cf-84f8-768b5384da45"} #Scrum
	}
	
	#Build JSON Data to Send To The Service
	$JSON = @"
	{
		"name": "$VSTS_ProjectName",
		"description": "$VSTS_ProjectDescription",
		"capabilities": {
			"versioncontrol": {
				"sourceControlType": "$VSTS_SourceControl"
			},
			"processTemplate": {
				"templateTypeId": "$VSTS_ProcessID"
			}
		}
	}
"@
	#Debug
	Write-Verbose $JSON
	
	#Build Request URI
	$RequestURI = $VSTS_URL + "/_apis/projects?api-version=" + $APIVersion
	
	#Create VSTS Project
	try
	{
		$NewProject = Invoke-RestMethod -ContentType "application/json" -Uri $RequestURI -Headers $Headers -Method POST -Body $JSON
		#Return Project Results
		return $NewProject | FL
	}
	catch
	{
		throw "Unable To Create New VSTS Project.`n$($Error[0].Exception)"
	}
}

#Done
function New-VSTSServiceEndPoint
{
		<#
	.SYNOPSIS
		Creates a new VSTS project service endpoint.
	.DESCRIPTION
		Creates a new VSTS project service endpoint, must be authorized for the given VSTS tenant.
	.EXAMPLE
		New-VSTSServiceEndpoint -VSTS_InstanceName "tenantname" -VSTS_Username "username" -VSTS_PersonalAccessToken "yourtoken" -VSTS_ProjectName "newprojectname"
	.PARAMETER VSTS_InstanceName
		The prefix used to define the VSTS tenant name. For example, sean.visualstudio.com, your tenant name would be "sean".
	.PARAMETER VSTS_Username
		The username the Personal Access Token belongs to.
	.PARAMETER Personal_Access_Token
		Your personal Access Token. To setup a PAT, refer to this article: http://blogs.msdn.com/b/buckh/archive/2013/01/07/how-to-connect-to-tf-service-without-a-prompt-for-liveid-credentials.aspx
		You can also go to the PAT direct link: https://yourtenantname.visualstudio.com/_details/security/tokens/Edit
	.PARAMETER VSTS_ProjectName
		Name of new project you want to create in VSTS.
	.PARAMETER VSTS_ServiceEndpointName
		The service endpoint friendly name.
	.PARAMETER VSTS_ServiceEndpointType
		The service parameter endpoint type. The options are (Generic, Github, TFS)
	.PARAMETER VSTS_ServiceEndpointURL
		The service endpoint url to connect to the repository.
	.PARAMETER VSTS_ServiceEndpointUsername
		The service endpoint authorized username.
	.PARAMETER VSTS_ServiceEndpointPassword
		The service endpoint authorized user account password.
	#>
  
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$False, HelpMessage='Name of the VSTS Tenant?')]
		[string]$VSTS_InstanceName,

		[Parameter(Mandatory=$False, HelpMessage='VSTS Tenant Login Username?')]
		[string]$VSTS_UserName,

		[Parameter(Mandatory=$False, HelpMessage='Personal Access Token')]
		[string]$VSTS_PersonalAccessToken,

		[Parameter(Mandatory=$True, HelpMessage='New Project Name?')]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_ProjectName,
	
		[Parameter(Mandatory=$True, HelpMessage='Name for new service endpoint?')]
		[string]$VSTS_ServiceEndpointName,
		
		[Parameter(Mandatory=$True, HelpMessage='Service endpoint type?')]
		[string]$VSTS_ServiceEndpointType = "Git",
		
	    [Parameter(Mandatory=$True, HelpMessage='URL of service endpoint?')]
		[string]$VSTS_ServiceEndpointURL,
		
		[Parameter(Mandatory=$True, HelpMessage='URL of service endpoint?')]
		[string]$VSTS_ServiceEndpointUsername,
		
		[Parameter(Mandatory=$True, HelpMessage='URL of service endpoint?')]
		[string]$VSTS_ServiceEndpointPassword
	)

	#Set API Version
	$APIVersion = "3.0-preview.1"

	#Build VSTS Base Link
	$VSTS_URL = 'https://' + $VSTS_InstanceName + '.visualstudio.com/DefaultCollection/' + $VSTS_ProjectName #Base url for all of the VSO API calls 

	#Base64 Encode The Personal Access Token (PAT)
	$VSTS_EncodedPersonalAccessToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $VSTS_UserName,$VSTS_PersonalAccessToken)))

	#Setup Headers
	$Headers = @{Authorization=("Basic {0}" -f $VSTS_EncodedPersonalAccessToken)}

	#Build JSON Data to Send To The Service (Generic Connection - Update For Others Later)
	$JSON = @"
	{
	  "name": "$VSTS_ServiceEndpointName",
	  "type": "$VSTS_ServiceEndpointType",
	  "url": "$VSTS_ServiceEndpointURL",
	  "authorization": {
		"scheme": "UsernamePassword",
		"parameters": {
		  "username": "$VSTS_ServiceEndpointUsername",
		  "password": "$VSTS_ServiceEndpointPassword"
		}
	  }
	}
"@
	#Debug
	Write-Verbose $JSON
	
	#Build Request URI
	$RequestURI = $VSTS_URL + "/_apis/distributedtask/serviceendpoints?api-version=" + $APIVersion

	try
	{
		#Create VSTS Project
		$NewServiceEndpoint = Invoke-RestMethod -ContentType "application/json" -Uri $RequestURI -Headers $Headers -Method POST -Body $JSON
	
		#Return Project Results
		return $NewServiceEndpoint
	}
	catch
	{
		throw "Unable To Create New VSTS Project.`n$($Error[0].Exception)"
	}
}

#In Progress - Almost Done
function New-VSTSRepoImportRequest
{
		<#
	.SYNOPSIS
		Creates a new VSTS project.
	.DESCRIPTION
		Creates a new VSTS project, must be authorized for the given VSTS tenant.
	.EXAMPLE
		Create-VSTSProjects -VSTS_InstanceName "tenantname" -VSTS_Username "username" -PersonalAccessToken "yourtoken" -VSTS_ProjectName "newprojectname"
	.PARAMETER VSTS_InstanceName
		The prefix used to define the VSTS tenant name. For example, sean.visualstudio.com, your tenant name would be "sean".
	.PARAMETER VSTS_Username
		The username the Personal Access Token belongs to.
	.PARAMETER Personal_Access_Token
		Your personal Access Token. To setup a PAT, refer to this article: http://blogs.msdn.com/b/buckh/archive/2013/01/07/how-to-connect-to-tf-service-without-a-prompt-for-liveid-credentials.aspx
		You can also go to the PAT direct link: https://yourtenantname.visualstudio.com/_details/security/tokens/Edit
	.PARAMETER VSTS_ProjectName
		Name of new project you want to create in VSTS.
	.PARAMETER VSTS_RepositoryID
		ID of the destination repo in VSTS. Most likely is always the same as project name.
	#>
  
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$True, HelpMessage='Name of the VSTS Tenant?')]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_InstanceName,

		[Parameter(Mandatory=$True, HelpMessage='VSTS Tenant Login Username?')]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_UserName,

		[Parameter(Mandatory=$True, HelpMessage='Personal Access Token?')]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_PersonalAccessToken,

		[Parameter(Mandatory=$True, HelpMessage='New Project Name?')]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_ProjectName = "",
		
		[Parameter(Mandatory=$True, HelpMessage='Repo ID?')]
		[ValidateNotNullOrEmpty()]
		[string]$VSTS_RepositoryName
	)

	#Set API Version
	$APIVersion = "3.0-preview"

	#Build VSTS Base Link
	$VSTS_URL = 'https://' + $VSTS_InstanceName + '.visualstudio.com/DefaultCollection/' + $VSTS_ProjectName #Base url for all of the VSO API calls 

	#Base64 Encode The Personal Access Token (PAT)
	$VSTS_EncodedPersonalAccessToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $VSTS_UserName,$VSTS_PersonalAccessToken)))

	#Setup Headers
	$Headers = @{Authorization=("Basic {0}" -f $VSTS_EncodedPersonalAccessToken)}
	
	#Build JSON Data to Send To The Service (For Generic - Have To Write The Rest)
	$JSON = @"
	{
	  "parameters":
		{
		  "gitSource":
			{
			  "url": "https://github.com/imseandavis/uManage"
			},
		  "deleteServiceEndpointAfterImportIsDone": "$false
		}
	}
"@	
	
	#Debug
	Write-Verbose $JSON

	#Build Request URI
	$RequestURI = $VSTS_URL + "/_apis/git/repositories/" + $VSTS_RepositoryName + "/importRequests?api-version=" + $APIVersion

	#Set Repo To Not Found
	$RepoSearchCount = 0
	$FoundRepo = $false
	
	#Look For Repo And Retry For Up To 60 Seconds
	do
	{
		#Update Repo Search Counter
		$RepoSearchCount++
		
		Write-Host "Checking To See If Repository: $VSTS_RepositoryName Exists..."
		
		try
		{
			#Check To See If The Repo Already Exists
			if($((Get-VSTSRepositoryList -VSTS_InstanceName $VSTS_InstanceName -VSTS_Username $VSTS_Username -VSTS_PersonalAccessToken $VSTS_PersonalAccessToken | Where {$_.Name -eq "$VSTS_RepositoryName"}) | Measure-Object | Select Count -ExpandProperty Count) -gt 0)
			{
				#Found The Repo!
				$FoundRepo = $true
				
				#Create The Import Request
				$NewImportRequest = Invoke-RestMethod -ContentType "application/json" -Uri $RequestURI -Headers $Headers -Method POST -Body $JSON
				
				#Return Import Request Results
				return $NewImportRequest
			}
		}
		catch
		{
			throw "Unable To Create An Import Request.`n$($Error[0].Exception)"
		}
		
		Write-Host "Repository May Still Be Building Or You Have Defined The Wrong Repository, Retrying $(12 - $RepoSearchCount) more times..."
		Sleep 5
	}
	while ($FoundRepo -eq $false)
}
