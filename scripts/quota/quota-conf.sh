#!/bin/bash

# SEE: https://www.centos.org/docs/5/html/Deployment_Guide-en-US/ch-disk-quotas.html

# Create the quota group for home.
groupadd qhome

# Create the quota group for share.
groupadd qshare

# Modify the /etc/fstab and find the line where is the /home partition and
# add this:
#
# grpquota 0 0

# You need to also find the /srv/share partition line in the /etc/fstab and
# add this:
#
# grpquota 0 0

# Unmout the /home partition.
fuser -k /dev/mapper/VolGroup-LVhome
umount -l /dev/mapper/VolGroup-LVhome

#Mount again the /home partition.
mount /dev/mapper/VolGroup-LVhome

# [ NOTE: Do the same with /srv/share]

# Generate the files aquota.group on the filesystem.
quotacheck -cg /home
quotacheck -cg /srv/share

# Generate the table of the disk usage by the system with the
# actvation of the quota.

quotacheck -avg

# Activate the quota
quotaon -avg

# Assigning Quotas for qhome
# Pick:
#       Soft Limits: 400Mo
#       Hard Limits: 500Mo
edquota -g qhome

# Assigning Quotas for qshare
# Pick:
#       Soft Limits: 400Mo
#       Hard Limits: 500Mo
edquota -g qshare
