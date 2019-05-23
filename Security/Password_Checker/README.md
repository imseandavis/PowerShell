## HAVEIBEENPWNED Breached Password Checker
Put the current password your using into the checker and it will go out and retrieve all instances of the password found on HAVEIBEENPWNED.COM using the [HAVEIBEENPWNED API](https://haveibeenpwned.com/API/v2).<br>

## Instructions
Run the script and put your password in and it will notify you how many times your password has been found in a public list or data breach.
<br><br>
Here's how the magic happens...<br>
* You Enter Your Password (I Let It Display In Clear Text So You Can Tell If You Type It Correctly)
* A Hash Is Created From Your Password So You Don't Expose Your Password To The HAVEIBEENPWND Service
* The First 5 Bytes Of The Hash Are Sent To The API So You Don't Compromise Your Hash
* All Hashes That Start With The 5 Bytes Sent Are Returned
* PowerShell Locally Checks For Exact Matches To Your Password Hash And Reports How Many Times It Was Found

# Good Response
![Breached Password Checker CLI Good Response](PasswordBreachCheckerCLI-Good.png)
<br>
# Bad Response
![Breached Password Checker CLI Good Response](PasswordBreachCheckerCLI-Bad.png)
