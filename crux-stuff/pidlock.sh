#!/bin/bash

#
# short script to include in other scripts
# for making sure there is no dual run
#

LCK_FILE=/tmp/`basename $0`.lck

if [ -f "${LCK_FILE}" ]; then

	# still running?
	MYPID=`head -n 1 $LCK_FILE`
	if [ -n "`ps -p ${MYPID} | grep ${MYPID}`" ]; then
		# already running
		echo `basename $0` is already running [$MYPID].
		exit
	fi
fi

echo $$ > $LCK_FILE
