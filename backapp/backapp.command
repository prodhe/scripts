#!/bin/bash
#
# BackApp
#
# Simple backup script
#

VERSION="v1.0"

#
#
#   BEGIN
#
#

# change to script directory
NEWDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $NEWDIR

# source the config file
source ./default.conf

# internal variables
LOGFILE=/tmp/backapp-`date +%y%m%d-%H%M`.log
ARGS_OK=0
RUN_STATE=0
DRY_RUN=0
DELIMITER="----------------------------------------------"

# header
echo "BackApp $VERSION"

# check arguments passed on
for arg in $@; do
    case $arg in
        "--noconfirm")
            RUN_STATE=1
            ;;
        "--test")
            DRY_RUN=1
            ;;
        "-h"|"--help"|"help")
            echo "usage: $0 [OPTIONS]"
            echo "A simple backup tool using BASH and rsync."
            echo
            echo -e -n  "\tOptions:\n" \
                        "\t\t--noconfirm\n" \
                        "\t\t\twill not prompt for confirmation before start\n" \
                        "\t\t--test\n" \
                        "\t\t\tsends --dry-run option to rsync\n" \
                        "\t\t\tand will not perform any backup\n" \
                        "\t\t--help\n" \
                        "\t\t\tshow this help and exit"
            echo -e "\n"
            echo "Created by Petter Rodhelind 2011-2014"
            exit
            ;;
    esac
done


# add username to source dir
if [ $TRAIL_USER = 1 ]; then
    # trail current user to source and destination dir
    SOURCE_DIR="$SOURCE_DIR/$(whoami)/"
    DEST_DIR="$DEST_DIR/$(whoami)"
fi

# check for dry run from config
if [[ $CMD_OPTS =~ --dry-run ]]; then
    DRY_RUN=1
fi

# scream in case of a test run
if [ $DRY_RUN != 0 ]; then
    echo "TEST RUN: No data will be copied!"
fi

# if --noconfirm is not given, show settings and prompt for proceed
if [ $RUN_STATE = 0 ]; then
    echo -e "\n$SOURCE_DIR ---> $DEST_DIR\n"
    read -n 1 -s -p "Do you wish to proceed? [y/n]" yn
    echo
    if [ "$yn" != "y" ]; then
        echo Good bye
        exit
    fi
fi

# require root for automounting during script run
if [ $DO_NOT_MOUNT = 0 ]; then
    # check root
    if [ "` whoami `" != "root" ]; then
        echo "Must be logged in as root to mount external devices."
        exit
    fi
fi

# line
echo $DELIMITER

# mount if chosen in config
if [ $DO_NOT_MOUNT = 0 ]; then
    # mount
    echo -n "Mounting $DEV: "
    if [ -b $DEV -a -d $MOUNT_POINT ]; then
        mount $DEV $MOUNT_POINT &> /dev/null
        sleep 3
            if [ $? != 0 ]; then
                echo "ERROR"
                echo "Do a 'mount $DEV $MOUNT_POINT' manually to see what's wrong..."
                exit
            fi
        echo "OK"
    else
        echo "ERROR"
        echo "$DEV or $MOUNT_POINT does not exist."
        echo
        echo "Check your configuration."
        exit
    fi
fi

# trail user config
if [ $TRAIL_USER = 1 ]; then
    # create current user as subfolder to destination dir
    if [ ! -d $DEST_DIR ]; then
        if [ $DRY_RUN != 0 ]; then
            echo "Would have created the directory: $DEST_DIR"
        else
            mkdir $DEST_DIR
            echo "Created directory: $DEST_DIR"
        fi
    fi
fi

# check for previous backups in destination dir and save space using hard links
PREV_BKP=`ls -a -1 -r $DEST_DIR | egrep -m 1 'backup.[0-9]{6}[0-9]{4}$'`
if [ "$PREV_BKP" = "" ]; then
    echo "No previous backups found."
    echo "It may take a while since this is the first time..."
else
    echo "Found a previous backup"
    echo "Creating hardlinks to: ${PREV_BKP}"
    CMD_OPTS="$CMD_OPTS --link-dest=../$PREV_BKP"
fi

# setup the the actual dir to backup to (using today's date as suffix)
BASE_NAME="backup.`date +%y%m%d%H%M`"

# log
echo "Logging to: $LOGFILE"

# backup
echo "New backup: $DEST_DIR/$BASE_NAME"
echo "Running"
# check and print out in case of dry-run
if [ $DRY_RUN != 0 ]; then
       echo "--- TEST RUN ---"
       CMD_OPTS="$CMD_OPTS --dry-run"
fi
rsync -vv -azh --delete --log-file=$LOGFILE --include-from=$INCLUDE_FILE --exclude-from=$EXCLUDE_FILE $CMD_OPTS $SOURCE_DIR $DEST_DIR/$BASE_NAME &> /dev/null
echo "Backup complete"

# save the log next to the backup
echo -n "Moving logfile next to backup: "
if [ $DRY_RUN != 0 ]; then
    mv $LOGFILE $LOGFILE.testrun
    if [ $? -eq 0 ]; then echo "OK"; else echo "ERROR"; fi
else
    mv "$LOGFILE" "$DEST_DIR/$BASE_NAME.log"
    if [ $? = 0 ]; then echo "OK"; else echo "ERROR"; fi
    if [ "$PREV_BKP" != "" ]; then
        echo -n "Hiding old backup for easier browsing: "
        mv $DEST_DIR/$PREV_BKP $DEST_DIR/.$PREV_BKP
        if [ $? = 0 ]; then echo -n "OK "; else echo -n "ERROR "; fi
        mv $DEST_DIR/$PREV_BKP.log $DEST_DIR/.$PREV_BKP.log
        if [ $? = 0 ]; then echo "OK"; else echo "ERROR"; fi
    fi
fi

# unmount if chosen in config
if [ $DO_NOT_MOUNT = 0 ]; then
    # unmount
    echo -n "Unmounting $DEV: "
    sleep 5
    if umount $DEV; then echo "OK"; else echo "ERROR"; fi
fi

# announce success
echo $DELIMITER
if [ $DRY_RUN != 0 ]; then
    echo "Performed test run."
fi
echo "Done."

exit
