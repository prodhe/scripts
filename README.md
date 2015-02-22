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

Bash script using rsync and hard links between backups to save disk space.
Can do automatic mounting of devices and add a trailing username for the
destination dir.

## checknet

Sends a ping, check for packets received and take action if not enough packets
went through. Waits for a desired time between checks and loops forever.

## github-create-repo

Bash script to create an online repo on github, without using the web browser. Got the original
from [jsw883/github-create-repo](https://github.com/jsw883/github-create-repo).
Gets updated whenever I feel the need...
