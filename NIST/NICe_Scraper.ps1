# NIST Scraper v1.1
# Scrapes cisa.gov site for NIST Work Roles / Abilties / Knowledge / Skills /  From Website and Dumps Them Into A MySQL Database
# TODO: Upload the DB Schema
# Script Version: 1.34
# PSVersion: 5.2
# By: Sean Davis (imseandavis)


# Init Variables
$DBServer = "YOUR_SERVER_HERE"
$DBName = "YOUR_DBNAME_HERE"
$DBUser = "YOUR_USER_HERE"
$DBPass = "YOUR_PASS_HERE"
$Abilities_BaseURL = "https://niccs.cisa.gov/workforce-development/cyber-security-workforce-framework/abilities"
$Knowledge_BaseURL = "https://niccs.cisa.gov/workforce-development/cyber-security-workforce-framework/knowledge"
$Skills_BaseURL = "https://niccs.cisa.gov/workforce-development/cyber-security-workforce-framework/skills"
$Tasks_BaseURL = "https://niccs.cisa.gov/workforce-development/cyber-security-workforce-framework/tasks"
$WorkRoles_BaseURL = "https://niccs.cisa.gov/workforce-development/cyber-security-workforce-framework/workroles"

#Init The DB Connection
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$ConnectionString = "server=$DBServer;port=3306;database=$DBName;uid=$DBUser;pwd=$DBPass"
$MySQLConnection = New-Object MySql.Data.MySqlClient.MySqlConnection($ConnectionString)

# Connect To The DB
try
{
	$MySQLConnection.Open()
}
catch
{
	Write-Warning "Could Not Connect To Database!"
	Write-Warning "Error: " + $Error[0].ToString()
	Break;
}


#region Tasks

# Retrieve Task ID List
$TasksRequest = Invoke-WebRequest -URI $Tasks_BaseURL
$Tasks_ID_List = ($TasksRequest.ParsedHTML.getElementById('edit-id') | Select IHTMLOptionElement_value -Skip 1).IHTMLOptionElement_value

#Loop Through Task List
ForEach ($Task in $Tasks_ID_List)
{
	# Retrieve the Task Details
	$TaskLookup = Invoke-WebRequest -URI $("$Tasks_BaseURL" + "?id=$Task&description=All")
	$TaskID = $($TaskLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).InnerText.Split(":")[1].TrimStart()
	$TaskDescription = $($TaskLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).IHTMLDOMNode_nextSibling.InnerText.Split(":")[1].TrimStart()

	# Write The Details To The Database Table
	$Query = "INSERT into $DBName.nist_tasks (id, description) VALUES('$TaskID', @TaskDescription)"
	
	$MySQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
	$MySQLCommand = $MySQLConnection.CreateCommand()
	$MySQLCommand.CommandText = $Query
	$MySQLCommand.Parameters.AddWithValue("@TaskDescription", $TaskDescription) | Out-Null
	$RowsAffected = $MySQLCommand.ExecuteNonQuery()
	
	# Check To Make Sure The Record Was Properly Recorded
	If($RowsAffected -lt 1)
	{
		Write-Warning "Unable To Add Task ID: $Task Into The Database!"
		Write-Warning "Error: " + $Error[0].ToString()
	}
	else
	{
		Write-Host "Successfully Added Task ID: $Task !"
	}
}

#endregion Tasks


#region Knowledge

# Retrieve Knowledge ID List
$KnowledgeRequest = Invoke-WebRequest -URI $Knowledge_BaseURL
$Knowledge_ID_List = ($KnowledgeRequest.ParsedHTML.getElementById('edit-id') | Select IHTMLOptionElement_value -Skip 1).IHTMLOptionElement_value

#Loop Through Knowledge List
ForEach ($Knowledge in $Knowledge_ID_List)
{
	# Retrieve the Knowledge Details
	$KnowledgeLookup = Invoke-WebRequest -URI $("$Knowledge_BaseURL" + "?id=$Knowledge&description=All")
	$KnowledgeID = $($KnowledgeLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).InnerText.Split(":")[1].TrimStart()
	$KnowledgeDescription = $($KnowledgeLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).IHTMLDOMNode_nextSibling.InnerText.Split(":")[1].TrimStart()

	# Write The Details To The Database Table
	$Query = "INSERT into $DBName.nist_knowledge (id, description) VALUES('$KnowledgeID', @KnowledgeDescription)"
	
	$MySQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
	$MySQLCommand = $MySQLConnection.CreateCommand()
	$MySQLCommand.CommandText = $Query
	$MySQLCommand.Parameters.AddWithValue("@KnowledgeDescription", $KnowledgeDescription) | Out-Null
	$RowsAffected = $MySQLCommand.ExecuteNonQuery()
	
	# Check To Make Sure The Record Was Properly Recorded
	If($RowsAffected -lt 1)
	{
		Write-Warning "Unable To Add Knowledge ID: $Knowledge Into The Database!"
		Write-Warning "Error: " + $Error[0].ToString()
	}
	else
	{
		Write-Host "Successfully Added Knowledge ID: $Knowledge !"
	}
}

#endregion Knowledge


#region Skills

# Retrieve Skills ID List

$SkillsRequest = Invoke-WebRequest -URI $Skills_BaseURL
$Skills_ID_List = ($SkillsRequest.ParsedHTML.getElementById('edit-id') | Select IHTMLOptionElement_value -Skip 1).IHTMLOptionElement_value

#Loop Through Skills List
ForEach ($Skill in $Skills_ID_List)
{
	# Retrieve the Skill Details
	$SkillLookup = Invoke-WebRequest -URI $("$Skills_BaseURL" + "?id=$Skill&description=All")
	$SkillID = $($SkillLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).InnerText.Split(":")[1].TrimStart()
	$SkillDescription = $($SkillLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).IHTMLDOMNode_nextSibling.InnerText.Split(":")[1].TrimStart()

	# Write The Details To The Database Table
	$Query = "INSERT into $DBName.nist_skills (id, description) VALUES('$SkillID', @SkillDescription)"
	
	$MySQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
	$MySQLCommand = $MySQLConnection.CreateCommand()
	$MySQLCommand.CommandText = $Query
	$MySQLCommand.Parameters.AddWithValue("@SkillDescription", $SkillDescription) | Out-Null
	$RowsAffected = $MySQLCommand.ExecuteNonQuery()
	
	# Check To Make Sure The Record Was Properly Recorded
	If($RowsAffected -lt 1)
	{
		Write-Warning "Unable To Add Skill ID: $Skill Into The Database!"
		Write-Warning "Error: " + $Error[0].ToString()
	}
	else
	{
		Write-Host "Successfully Added Skill ID: $Skill !"
	}
}

#endregion Skills


#region Abilities

# Retrieve Ability ID List
$AbilitiesRequest = Invoke-WebRequest -URI $Abilities_BaseURL
$Abilities_ID_List = ($AbilitiesRequest.ParsedHTML.getElementById('edit-id') | Select IHTMLOptionElement_value -Skip 1).IHTMLOptionElement_value

#Loop Through Abilities List
ForEach ($Ability in $Abilities_ID_List)
{
	# Retrieve the Ability Details
	$AbilityLookup = Invoke-WebRequest -URI $("$Abilities_BaseURL" + "?id=$Ability&description=All")
	$AbilityID = $($AbilityLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).InnerText.Split(":")[1].TrimStart()
	$AbilityDescription = $($AbilityLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).IHTMLDOMNode_nextSibling.InnerText.Split(":")[1].TrimStart()
	
	# Write The Details To The Database Table
	$Query = "INSERT into $DBName.nist_abilities (id, description) VALUES('$AbilityID', @AbilityDescription)"
	
	$MySQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
	$MySQLCommand = $MySQLConnection.CreateCommand()
	$MySQLCommand.CommandText = $Query
	$MySQLCommand.Parameters.AddWithValue("@AbilityDescription", $AbilityDescription) | Out-Null
	$RowsAffected = $MySQLCommand.ExecuteNonQuery()
	
	# Check To Make Sure The Record Was Properly Recorded
	If($RowsAffected -lt 1)
	{
		Write-Warning "Unable To Add Ability ID: $Ability Into The Database!"
		Write-Warning "Error: " + $Error[0].ToString()
	}
	else
	{
		Write-Host "Successfully Added Ability ID: $Ability !"
	}
}

#endregion Abilities


#region Work Roles

# Retrieve Work Role ID List
$WorkRoleRequest = Invoke-WebRequest -URI $WorkRoles_BaseURL
$Work_Role_ID_List = ($WorkRoleRequest.ParsedHTML.getElementById('edit-id') | Select IHTMLOptionElement_value -Skip 1).IHTMLOptionElement_value

#Loop Through Work Roles List
ForEach ($Work_Role in $Work_Role_ID_List)
{
	# Retrieve the Work Role Details
	$WorkRoleLookup = Invoke-WebRequest -URI $("$WorkRoles_BaseURL" + "?name=All&id=$Work_Role")
	$WorkRoleID = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).InnerText.Split(":")[1].TrimStart()
	$WorkRoleName = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).IHTMLDOMNode_previousSibling.InnerText
	$WorkRoleDescription = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('fwid')).IHTMLDOMNode_nextSibling.InnerText
	$WorkRoleCategory = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('wr-category-wrapper')).InnerText.Split(":")[1].TrimStart()
	$WorkRoleSpecialtyArea = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('wr-sa-wrapper')).InnerText.Split(":")[1].TrimStart()
		
	#Retrieve Work Role Abilities
	$WorkRoleAbilitiesList = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('usa-list'))[1].children | Select InnerText
	$WorkRoleAbilities = [PSCustomObject]@{}
	ForEach ($WRA in $WorkRoleAbilitiesList)
	{
		$WorkRoleAbilities | Add-Member -MemberType NoteProperty -Name $WRA.InnerText.Split(":")[0].Trim() -Value $WRA.InnerText.Split(":")[1].Trim()
	}
	$AbilityJSON = ConvertTo-JSON $WorkRoleAbilities
	
	#Retrieve Work Role Knowledge
	$WorkRoleKnowledgeList = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('usa-list'))[2].children | Select InnerText
	$WorkRoleKnowledge = [PSCustomObject]@{}
	ForEach ($WRK in $WorkRoleKnowledgeList)
	{
		$WorkRoleKnowledge | Add-Member -MemberType NoteProperty -Name $WRK.InnerText.Split(":")[0].Trim() -Value $WRK.InnerText.Split(":")[1].Trim()
	}
	$KnowledgeJSON = ConvertTo-JSON $WorkRoleKnowledge
		
	#Retrieve Work Role Skills
	$WorkRoleSkillList = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('usa-list'))[3].children | Select InnerText
	$WorkRoleSkills = [PSCustomObject]@{}
	ForEach ($WRS in $WorkRoleSkillList)
	{
		$WorkRoleSkills | Add-Member -MemberType NoteProperty -Name $WRS.InnerText.Split(":")[0].Trim() -Value $WRS.InnerText.Split(":")[1].Trim()
	}
	$SkillsJSON = ConvertTo-JSON $WorkRoleSkills
	
	#Retrieve Work Role Tasks
	$WorkRoleTaskList = $($WorkRoleLookup.ParsedHTML.Body.GetElementsByClassName('usa-list'))[4].children | Select InnerText
	$WorkRoleTasks = [PSCustomObject]@{}
	ForEach ($WRT in $WorkRoleTaskList)
	{
		# Replace Hack At The End To Pull Out Quotes From Scraped Data, This Fixes MySQL JSON TYPE INSERT.
		$WorkRoleTasks | Add-Member -MemberType NoteProperty -Name $WRT.InnerText.Split(":")[0].Trim() -Value $WRT.InnerText.Split(":")[1].Trim().Replace('"','')
	}
	$TasksJSON = ConvertTo-JSON $WorkRoleTasks

	# Write The Details To The Database Table
	$Query = "INSERT into $DBName.nist_work_roles (id, name, description, category, specialty_area, knowledge, skills, abilities, tasks) VALUES('$WorkRoleID', '$WorkRoleName', @WorkRoleDescription, '$WorkRoleCategory', '$WorkRoleSpecialtyArea', '$KnowledgeJSON', '$SkillsJSON', '$AbilityJSON', '$TasksJSON')"
	
	$MySQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
	$MySQLCommand = $MySQLConnection.CreateCommand()
	$MySQLCommand.CommandText = $Query
	$MySQLCommand.Parameters.AddWithValue("@WorkRoleDescription", $WorkRoleDescription) | Out-Null
	$MySQLCommand.Parameters.AddWithValue("@KnowledgeJSON", $KnowledgeJSON) | Out-Null
	$MySQLCommand.Parameters.AddWithValue("@SkillsJSON", $SkillsJSON) | Out-Null
	$MySQLCommand.Parameters.AddWithValue("@AbilityJSON", $AbilityJSON) | Out-Null
	$MySQLCommand.Parameters.AddWithValue("@TasksJSON", $($TasksJSON | ConvertTo-JSON)) | Out-Null
	$RowsAffected = $MySQLCommand.ExecuteNonQuery()

	# Check To Make Sure The Record Was Properly Recorded
	If($RowsAffected -lt 1)
	{
		Write-Warning "Unable To Add Work Role ID: $Work_Role Into The Database!"
		Write-Warning "Error: " + $Error[0].ToString()
	}
	else
	{
		Write-Host "Successfully Added Work Role ID: $Work_Role !"
	}
}

#endregion Work Roles
