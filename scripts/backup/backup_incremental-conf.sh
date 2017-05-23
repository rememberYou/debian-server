#!/bin/bash

# SEE: https://wiki.archlinux.org/index.php/full_system_backup_with_rsync

# Installation of packages
apt-get install -y rsync fcron

# [ NOTE: You need to do that by yourself, otherwise the script will do that
#         everytime we run it. We will need to check how do the fcron
#         with the script only once time ]

# fcron -e 0 2 * * * /usr/bin/backup_incremential-conf.sh

# Restart fcron
# /etc/init.d/fcron restart

# Create the backup differential directory if doesn't exist yet.
if [[ ! -d /mnt/incremental ]]; then
    mkdir /mnt/incremental
fi

# Run the following command as root to make sure that rsync can access all system files and preserve the ownership.

# [ NOTE: if the following command doesn't work, you can try with the -r for the recursivity.
#         I though that it could be better to create two folders, one for the differential
#         backup and another one for the incremental backup.
#
#         With that configuration, we can create a crontab every day to make the incremental backup
#         and also the differential backup with rsync the sunday. ]


# For the differential backup.
rsync -aAXH --delete --info=progress2 --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/share"} / /mnt/incremental

# By using the -aAX set of options, the files are transferred in archive mode which
# ensures that symbolic links, devices, permissions, ownerships, modification times,
# ACLs, and extended attributes are preserved, assuming that the target file system
# supports the feature.

# The --exclude option causes files that match the given patterns to be excluded.
# The contents of /dev, /proc, /sys, /tmp, and /run are excluded in the above command,
# because they are populated at boot, although the folders themselves are not created.
# /lost+found is filesystem-specific.

# When using a different shell, --exclude patterns should be repeated manually.
# Quoting the exclude patterns will avoid expansion by the shell, which is necessary,
# for example, when backing up over SSH. Ending the excluded paths with * ensures that
# the directories themselves are created if they do not already exist.

# [ NOTE: I am not really sure if we really need to do that in our case. Feel free to
#         take the decision to do that or not. ]

# Having a bootable backup can be useful in case the filesystem becomes corrupt or if
# an update breaks the system. The backup can also be used as a test bed for updates,
# with the testing repo enabled, etc. If you transferred the system to a different
# partition or drive and you want to boot it, the process is as simple as updating
# the backup's /etc/fstab and your bootloader's configuration file.

# Without rebooting, edit the backup's fstab by commenting out or removing any existing
# entries. Add one entry for the partition containing the backup like the example here:

# [ NOTE: Alexandre, be careful because we need to replace the /dev/sdaX by the boot's partition,
#         but as we don't have it, we can't do that right now. ]
echo "/dev/sdaX    /             ext4      defaults                 0   1" >> /mnt/incremental/etc/fstab

# For update the bootloader's configuration file with GRUB, it is recommended that you
# automatically re-generate the main configuration file.

grub-mkconfig -o /boot/grub/grub.cfg

# Verify the new menu entry in /boot/grub/grub.cfg. Make sure the UUID is matching the new partition,
# otherwise it could still boot the old system. Find the UUID of a partition as follows:

lsblk -no NAME,UUID /dev/sdb3

# Where you substitute the desired partition for /dev/sdb3. To list the UUIDs of partitions grub
# thinks it can boot, use grep:

grep UUID= /boot/grub/grub.cfg

# Reboot the computer and select the right entry in the bootloader. This will load the system for the
# first time. All peripherals should be detected and the empty folders in / will be populated.
# Now you can re-edit /etc/fstab to add the previously removed partitions and mount points.
