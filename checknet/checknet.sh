#!/bin/sh

#
# Try changing the -b flag to -I (capital i) in row 24 if your
# ping does not work. The implementation differs from system
# to system. Or just "man ping" and see what flag is used to
# specify source interface.
#


# ping options
dest=8.8.8.8
src=en0

pingtries=5
threshold=3

# time to wait in seconds before trying again
timer=180

# the command to execute, if the ping fails
action="echo no connection"


# script

while true; do
    ping=$(ping -c "$pingtries" -b "$src" "$dest")
    packets=$(echo "$ping" | grep -o "[0-9] packets received" | awk '{print $1}')
    if [[ "$packets" -lt "$threshold" ]]
    then
        $action
    fi
    sleep "$timer"
done
