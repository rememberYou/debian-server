#!/bin/bash

# Install NFS
apt-get install nfs-common -y

# Create the NFS directory
mkdir -p /mnt/nfs

######################## AutoFS Configuration ########################

# Installation of AutoFS
apt-get install AutoFS

# Create a backup of the configuration file.
if [ ! -f /etc/auto.master.bk ]; then
    cp /etc/auto.master /etc/auto.master.bk
fi

# Create a backup of the configuration file.
if [ ! -f /etc/auto.nfs.bk ]; then
    cp /etc/auto.nfs /etc/auto.nfs.bk
fi

# Create the configuration file.
echo "/srv/    /etc/auto.nfs    --timeout=2,sync,nodev,nosuid" > /etc/auto.master

# Main AutoFS file.
echo  "nfs    -fstype=nfs,rw,inter    10.1.215.223:/srv/nfs" > /etc/auto.nfs

# Restart AutoFS.
/etc/init.d/autofs restart
