# Scripts


## bkp2dropbox

- Copy files using rsync to a folder in my local dropbox, in regular intervals using crontab
- Add the script to crontab manually


## pdfman

- Turns a unix man page into a nicelooking PDF-file using PostScript
Usage: ./pdfman.sh <manpage>


## route-flush

Shuts down the en0 interface and then repeatedly flushes the routes.
Useful in case the VPN tunnel gets screwed up...


## time_say

Reads the current time out loud, in intervals of 5 seconds, using 'say'


## backapp

Bash script using rsync and hard links to save disk space. Can do
automatic mounting of devices and add a trailing username for the
destination dir.
