#!/bin/bash

#		say `date "+%l %M and %S seconds"`

while [ 1 ]
	do z=`date +%S`
	if [ `expr $z % 5` -eq 0 ]; then
		say `date "+%l %M and %S seconds"`
	fi
done
