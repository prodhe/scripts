#!/bin/bash
#
# Show a run dialog
#

# check if the script is already running
source ~/.scripts/pidlock.sh

# check if input is valid
function checkcommand() {
    if [ "$RUN_CMD" != "" ]; then
        if [ -n `which $RUN_CMD &> /dev/null` ]; then
            gxmessage "Command not found!" -title "Run error" -borderless -center
            exit
        fi
    fi
}

# execute given input
function runcommand() {
    # force terminal prompt if sudo is typed
    if echo $RUN_CMD | egrep '^sudo'; then
        runterminal
    else
        exec $RUN_CMD &
    fi
}

# send input to terminal window
function runterminal() {
    exec aterm -e $RUN_CMD
}

# prompt for action
RUN_CMD=`gxmessage "Type command:" \
	-title "Run" \
	-borderless \
	-center \
    -entry \
	-buttons "_Run:2,_Terminal:3"`

# check the input
#checkcommand

# do stuff (case 1 is escape, hence do nothing)
case $? in
	2)
        runcommand
		;;
	3)
        runterminal
        ;;
esac
