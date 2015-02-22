#!/bin/bash

# check if the script is already running
source ~/.scripts/pidlock.sh

# prompt for action
xmessage "WARNING: The system will shut down." \
	-title "Shutdown" \
	-center \
	-buttons "Cancel:1,Reboot:2,Shutdown:3" \
	-default "Cancel"

# do stuff
case $? in
	1)
		;;
	2)
		sudo /sbin/shutdown -r now
		;;
	3)
		sudo /sbin/shutdown -h now
		;;
esac

#EOF
