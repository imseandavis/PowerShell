Description 
-----------
This script was written to automate the setup of a simple baremetal backup job using windows backup for all drives in the server to a network drive.


Disclaimer
----------
This script was intentionally set with false variables to show the concept, although those variables could be changed to a real value and with minor modifications the script will sucessfully execute and product a OSReload Image of any Windows 2008 R2 Server with windows backup feature installed.


Purpose
-------
This script would be useful to run immediately after a new server is created to snapshot it's state before any customizations are made to ensure a full baremetal restore in case of data corruption or improper configuration that would render the server unfixable. 
