#!/bin/bash

# Modify the /etc/fstab and find the line where is the /home partition and
# add this:
#
# defaults, usrquota

# Unmout the /home partition.
# fuser -k /dev/mapper/VolGroup-LVhome
# umount -l /dev/mapper/VolGroup-LVhome

# Mount again the /home partition.
# mount /dev/mapper/VolGroup-LVhome

# Generate the files aquota.user on the filesystem.
# quotacheck -cug /home

# Generate the table of the disk usage by the system with the
# actvation of the quota.

# quotacheck -avu

# Activate the quota

# quotaon -avu

# Use edquota -u <user> for quota
