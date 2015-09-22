#!/bin/sh
service='#!/bin/bash

# chkconfig: - 99 01
# description: Infomentum boot/shutdown scripts management

# Source function library.
. /etc/init.d/functions

LOCKFILE=/var/lock/subsys/infomentum_scripts

start() {
        echo "Starting script for Infomentum"

        if [ -f "$LOCKFILE" ]; then
        	echo " ###Service already started!###"
       		return 1
        fi

        touch $LOCKFILE
        /etc/infomentum/scripts/infomentum_boot_script.sh
        return 0
}

stop() {
        echo "Stopping script for Infomentum"
        
        if [ ! -f "$LOCKFILE" ]; then
        	echo " ###Service not started yet!###"
       		return 1
        fi

        /etc/infomentum/scripts/infomentum_shutdown_script.sh
        rm -rf $LOCKFILE
}

status() {
        echo "Chkconfig infomentum_scripts service:"
        chkconfig --list infomentum_scripts
        return 0
}

case "$1" in
    start)
        start && success || failure
        echo
        ;;

    stop)
        stop && success || failure
        echo
        ;;

    status)
        status
        ;;

  *)
        echo "Usage: $0 {start|stop|status}"
        exit 2
esac'

##Folders
mkdir -p /etc/infomentum/scripts

#Boot/Shutdown script
echo "Working on Infomentum Boot/Shutdown service..."
echo "$service" > /etc/init.d/infomentum_scripts
chmod +x /etc/init.d/infomentum_scripts
chkconfig --level 03456 infomentum_scripts on
echo 'Done!'

#Create empty scripts
echo '#!/bin/bash' > /etc/infomentum/scripts/infomentum_boot_script.sh
echo '#!/bin/bash' > /etc/infomentum/scripts/infomentum_shutdown_script.sh
chmod +x /etc/infomentum/scripts/infomentum_boot_script.sh
chmod +x /etc/infomentum/scripts/infomentum_shutdown_script.sh
echo 'Done!'