#!/bin/sh
# fork from:
# samba-4.2.3.tar.gz\samba-4.2.3\source4\scripting\bin\samba_backup
#
# Ready to CentOS7
# sernet-samba default paths

#work around
cp -a /etc/samba /var/lib/samba/etc


FROMWHERE=/var/lib/samba
WHERE=/backups/samba
DAYS=90                         # Set default retention period.
if [ -n "$1" ] && [ "$1" = "-h" -o "$1" = "--usage" ]; then
        echo "samba_backup [provisiondir] [destinationdir] [retpd]"
        echo "Will backup your provision located in provisiondir to archive stored"
        echo "in destinationdir for retpd days. Use - to leave an option unchanged."
        echo "Default provisiondir: $FROMWHERE"
        echo "Default destinationdir: $WHERE"
        echo "Default destinationdir: $DAYS"
        exit 0
fi

[ -n "$1" -a "$1" != "-" ]&&FROMWHERE=$1        # Use parm or default if "-".  Validate later.
[ -n "$2" -a "$2" != "-" ]&&WHERE=$2            # Use parm or default if "-".  Validate later.
[ -n "$3" -a "$3" -eq "$3" 2> /dev/null ]&&DAYS=$3      # Use parm or default if non-numeric (incl "-").

DIRS="private etc sysvol"
#Number of days to keep the backup
WHEN=`date +%Y-%m-%d`   # ISO 8601 standard date.

if [ ! -d $WHERE ]; then
        echo "Missing backup directory $WHERE"
        exit 1
fi
if [ ! -d $FROMWHERE ]; then
        echo "Missing or wrong provision directory $FROMWHERE"
        exit 1
fi

cd $FROMWHERE
for d in $DIRS;do
        relativedirname=`find . -type d -name "$d" -prune`
        n=`echo $d | sed 's/\//_/g'`
        if [ "$d" = "private" ]; then
                find $relativedirname -name "*.ldb.bak" -exec rm {} \;
                for ldb in `find $relativedirname -name "*.ldb"`; do
                        tdbbackup $ldb
                        Status=$?       # Preserve $? for message, since [ alters it.
                        if [ $Status -ne 0 ]; then
                                echo "Error while backing up $ldb - status $Status"
                                exit 1
                        fi
                done
                # Run the backup.
                #    --warning=no-file-ignored set to suppress "socket ignored" messages.
                tar cjf ${WHERE}/samba4_${n}.${WHEN}.tar.bz2  $relativedirname --exclude=\*.ldb --warning=no-file-ignored --transform 's/.ldb.bak$/.ldb/'
                Status=$?       # Preserve $? for message, since [ alters it.
                if [ $Status -ne 0 -a $Status -ne 1 ]; then     # Ignore 1 - private dir is always changing.
                        echo "Error while archiving ${WHERE}/samba4_${n}.${WHEN}.tar.bz2 - status = $Status"
                        exit 1
                fi
                find $relativedirname -name "*.ldb.bak" -exec rm {} \;
        else
                # Run the backup.
                #    --warning=no-file-ignored set to suppress "socket ignored" messages.
                tar cjf ${WHERE}/${n}.${WHEN}.tar.bz2  $relativedirname --warning=no-file-ignored
                Status=$?       # Preserve $? for message, since [ alters it.
                if [ $Status -ne 0 ]; then
                        echo "Error while archiving ${WHERE}/${n}.${WHEN}.tar.bz2 - status = $Status"
                        exit 1
                fi
        fi
done

find $WHERE -name "samba4_*bz2" -mtime +$DAYS -exec rm  {} \;
