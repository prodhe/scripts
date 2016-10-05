#!/bin/sh

if [ "$#" -ne 2 ] || ! [ -f $1 ]; then
    echo "Usage: <file> <md5-checksum>"
    exit 1
fi

f=`md5 -q $1`

if [ "$f" != "$2" ]; then
    echo "FAIL"
else
    echo "OK"
fi
