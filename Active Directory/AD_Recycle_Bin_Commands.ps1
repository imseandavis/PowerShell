# Load up the Active Directory modules
import-module activedirectory

# Turn on the Active Directory Recycling Bin -- Make sure to change the variables as noted in the line. 
Enable-ADOptionalFeature –Identity ‘CN=Recycle Bin Feature,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration, DC=INSERTDOMAINNAMEHERE,DC=INSERTCOMorLOCALorWhateverYourExtensionHere’ –Scope ForestOrConfigurationSet –Target ‘INSERTYOURFULLDOMAINNAMEHERE.WHATEVER’ 

#Get a User Account back--Just change the InsertUserNameHere to whatever User Name you want to get back. 
#Get-ADObject -Filter {displayName -eq "InsertUserNameHere"} -IncludeDeletedObjects | Restore-ADObject 

# Find Stuff--Use this to find stuff that's been deleted.
#Get-ADObject -SearchBase "CN=Deleted Objects,DC=InsertYourDomainNameHere,DC=InsertYourComOrLocalOrWhateverExtensionHere" -ldapFilter:"(msDs-lastKnownRDN=InsertTheObjectNameHere)" –IncludeDeletedObjects –Properties lastKnownParent
