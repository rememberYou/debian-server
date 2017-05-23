#!/bin/bash

# SEE: https://www.astuces-info.com/tag/quotatool/

# Installation of quotatool, useful for scripts.
apt-get install quota quotatool

# Add this to /etc/fstab to the /home line
usrquota,grpquota

quotacheck -cguvf /dev/mapper/VolGroup-LVhome
# quotacheck -cguvf /srv/share

# Initialize all the partitions that contains quotas in the /etc/fstab.
quotacheck -vagum

# Activate quota
quotaon -avug
