#!/bin/bash

# SEE: https://www.astuces-info.com/tag/quotatool/

# Installation of quotatool, useful for scripts.
apt-get install quota quotatool -y

# Unmout the /home partition.
fuser -k /dev/mapper/VolGroup-LVhome
umount -l /dev/mapper/VolGroup-LVhome

# Add this to /etc/fstab to the /home
#usrquota,grpquota

# Create the file 'aquota.user' and aquota.group' and initialize all the
# partitions that contains quotas in the /etc/fstab.
#quotacheck -cagumv
quotacheck -cguvf /dev/mapper/VolGroup-LVhome
quotacheck -vagum

# Mount the /home partition.
mount /dev/mapper/VolGroup-LVhome

# Activate quota
quotaon -avug
