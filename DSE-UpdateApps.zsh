#!/bin/zsh

# Author: Andrew W. Johnson
# Date: 2022.01.27
# Version: 3.00
# Organization: Stony Brook University/DoIT
#
# This script takes four paramaters, a path to a file/executable, a checksum, a trigger or
# policy ID, and an Epoch time.

# The script then checks the application listed in the first paramater, to see if it's newer 
# than the epoch time passed in paramater 4. If it's newer the script will exit.
#
# If the date is older, than it will check the MD5 Checksum of the file/executable and then
# if it does not match what is passed to the application in second paramater it will run 
# the policy that installs the updated file/executable by using a trigger or policy ID which
# is passed in the third paramater.
#
# Paramater 7 is where the version of the application is listed but it's not used. It's more
# a visual help in the Policy.

	# Command Line Arguments
# myApp=${1}
# myChecksum=${2}
# myTrigger=${3}
# myEpoch=${4}

	# Jamf Arguments
myApp=${4}
myChecksum=${5}
myTrigger=${6}
myEpoch=${8}

	# Debug echos.
# /bin/echo "${myApp}"
# /bin/echo "${myChecksum}"
# /bin/echo "${myTrigger}"
# /bin/echo "${myEpoch}"

	# Setup a digit check variable.
re='^[0-9]+$'

	# If the application is present on the computer, proceed.
if [[ -e ${myApp} ]]; then
		# If the application on the computer is newer than the one that is being installed,
		# then do nothing.
	existingEpoch=$(/usr/bin/stat -f "%m" "${myApp}" )
	echo "Found SW Epoch: ${existingEpoch}"
	if [ ${existingEpoch} -gt ${myEpoch} ]; then
		/bin/echo "${myApp} is newer than what wants to be installed."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myApp} is newer than what wants to be installed." >> /var/log/jamf.log
		exit 0
    fi
 
		# Check the checksum of the software installed and if it's not what is in the parameter
		# then update the software.  
	existingChecksum=$( /usr/bin/openssl md5 ${myApp} | /usr/bin/awk   -F '= '  '{print $2}' )
	if [[ ${existingChecksum} != ${myChecksum} ]]; then
		/bin/echo "${myApp} is not the correct version. Trying to replace it..."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myApp} is not the correct version. Trying to replace it..." >> /var/log/jamf.log
			# Run the Jamf Policy to install the updated app, via a trigger or policy ID.
		if [[ ${myTrigger} =~ ${re} ]]; then
			/usr/local/bin/jamf policy -trigger ${myTrigger}
		else
			/usr/local/bin/jamf policy -id ${myTrigger}
		fi
	else
		/bin/echo "${myApp} is at the correct version. No need to replace."
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myApp} is at the correct version. No need to replace." >> /var/log/jamf.log
	fi
else
	/bin/echo "${myApp} is not installed."
	/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: ${myApp} is not installed." >> /var/log/jamf.log
fi

exit 0
