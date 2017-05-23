#!/bin/bash

# SEE: https://www.astuces-info.com/tag/quotatool/

# Installation of quotatool, useful for scripts.
apt-get install quota quotatool

# Unmout the /home partition.
user -k /dev/mapper/VolGroup-LVhome
umount -l /dev/mapper/VolGroup-LVhome

# Unmout the /srv/share partition
user -k /srv/share
umount -l /srv/share

# Add this to /etc/fstab to the /home and /srv/share line
usrquota,grpquota

# Create the file 'aquota.user' and aquota.group' and initialize all the
# partitions that contains quotas in the /etc/fstab.
quotacheck -cagumv

# Mount the /home partition.
mount /dev/mapper/VolGroup-LVhome

# Mount the srv/share partition.
mount /srv/share

# Activate quota
quotaon -avug
