#!/bin/bash

# SEE: https://www.centos.org/docs/5/html/Deployment_Guide-en-US/ch-disk-quotas.html

# Installation of quotatool, useful for scripts.
apt-get install quotatool

# [ NOTE: I'm not even sure if we need to do that with quotatool... ]

# Modify the /etc/fstab and find the line where is the /home partition and
# add this:
#
# usrquota 0 0

# You need to also find the /srv/share partition line in the /etc/fstab and
# add this:
#
# usrquota 0 0

# Unmout the /home partition.
fuser -k /dev/mapper/VolGroup-LVhome
umount -l /dev/mapper/VolGroup-LVhome

#Mount again the /home partition.
mount /dev/mapper/VolGroup-LVhome

# [ NOTE: Do the same with /srv/share]

# Generate the files aquota.user on the filesystem.
quotacheck -cu /home
quotacheck -cu /srv/share

# Generate the table of the disk usage by the system with the
# actvation of the quota.

quotacheck -avu

# Activate the quota
quotaon -avu
