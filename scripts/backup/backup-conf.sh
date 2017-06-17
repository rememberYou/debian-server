#!/bin/bash

# SEE: https://wiki.archlinux.org/index.php/full_system_backup_with_rsync

# Installation of packages
apt-get install -y rsync cron

# Places the backup scripts at the right Places
cp backup-make.sh /usr/bin/backup-make.sh

# Create the incremental backup directory if doesn't exist yet.
if [[ ! -d /mnt/incremental ]]; then
    mkdir /mnt/incremental
fi

# Create the differential backup directory if doesn't exist yet.
if [[ ! -d /mnt/differential ]]; then
    mkdir /mnt/differential
fi

# Run the following command as root to make sure that rsync can access all system files and preserve the ownership.

# [ NOTE: if the following command doesn't work, you can try with the -r for the recursivity.
#         I though that it could be better to create two folders, one for the differential
#         backup and another one for the incremental backup.
#
#         With that configuration, we can create a crontab every day to make the incremental backup
#         and also the differential backup with rsync the sunday. ]

# [ NOTE: we will need to create the script to construct the script ]
chmod 700 /usr/bin/backup-make.sh

# Create the crontab for the execution of the script.
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/bin/backup-make.sh -i") | crontab -
(crontab -l 2>/dev/null; echo "0 2 * * 0 /usr/bin/backup-make.sh -d") | crontab -

# Restart cron
/etc/init.d/cron restart
