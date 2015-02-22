#!/bin/bash

# save current brightness and then dim screen
XBRIGHT=`xbacklight`
xbacklight -time 1 -set 0

# run xlock
xlock \
	-mode blank \
	-delay 10000 \
	-erasedelay 0 \
	-lockdelay 0 \
	+description \
	+enablesaver \
	-echokeys \
	-echokey "*" \
	-timeout 10 \
	-font 9x15 \
	-foreground grey80 \
	-background black \
	-mousemotion \
	+showdate \
	+usefirst \
	-icongeometry 70x28 \
	-info "Locked by `whoami` since `date +%H:%M:%S`." \
	-username "Username:   " \
	-password "Password:  "

# when xlock exits, light up the place once again
xbacklight -time 500 -set $XBRIGHT
