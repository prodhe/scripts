#!/bin/sh

#
# Variables
#

dest=8.8.8.8
src=en0

pingtries=5
threshold=3
timer=180

action="echo no connection"


#
# Script
#

while true; do
    ping=$(ping -c $pingtries -I $src $dest)
    packets=$(echo $ping | grep -o "[0-9] packets received" | awk '{print $1}')
    if [ $packets -lt $threshold ]
    then
        $action
    fi
    sleep $timer
done
