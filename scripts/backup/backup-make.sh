#!/bin/bash

# Use the incremental backup to back up the system.
function incremental() {
    rsync -aAXu --delete --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/share"} / /mnt/incremental
}

# Use the differential backup to back up the system.
function differential() {
    rsync -aAXu --delete --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/share"} / /mnt/differential
}

# Documentation of the program.
function help() {
    echo "Written by: Terencio Agozzino (rememberYou)"
    echo "            Alexandre Ducobu (Harchytekt)"
    echo "      Mail: terencio.agozzino@gmail.com"
    echo "            alexandre.ducobu@yahoo.be"
    echo " "
    echo -e "Copyright (c) 2017 Deep Blue\n"

    echo "saveMe: saveMe [dih]"
    echo -e "    Save everything you need for your OS.\n"

    echo "    Options:"
    echo "      -i  incremental backup for the system back up."
    echo "      -d  differential backup for the system back up."
    echo -e "      -h  help to use the script.\n"

    echo -e "    By default, -i were specified.\n"

    echo "    Exit Status:"
    echo "    Returns 0 unless an invalid option is given or the current directory"
    echo "    cannot be read."
}

while [ "$1" != "" ]; do
    case $1 in
	-d | --differential )   differential
				exit
				;;
        -i | --incremental )    incremental
				exit
				;;
        -h | --help )           help
                                exit
                                ;;
        * )                     incremental
				exit 1
    esac
    shift
done
