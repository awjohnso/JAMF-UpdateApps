# JAMF-UpdateApps
 A Jamf script that updates applications since Patch managment on Jamf is a disaster in terms of scheduling...
- Author: Andrew W. Johnson
- Date: 2022.01.27
- Version: 3.00
- Organization: Stony Brook University/DoIT
---
### Description

This script takes four paramaters, a path to a file/executable, a checksum, a trigger or policy ID, and an Epoch time.

The script then checks the application listed in the first paramater, to see if it's newer than the epoch time passed in paramater 4. If it's newer the script will exit.

If the date is older, than it will check the MD5 Checksum of the file/executable and then if it does not match what is passed to the application in second paramater it will run the policy that installs the updated file/executable by using a trigger or policy ID whichvis passed in the third paramater.

Paramater 7 is where the version of the application is listed but it's not used. It's more a visual help in the Policy.
