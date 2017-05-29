#!/bin/bash

# Installation of NFS.
apt-get install nfs-common -y

# Create the share directory if doesn't exist yet.
if [[ ! -d /mnt/share/users ]]; then
    mkdir /mnt/share/users
    chmod 777 /mnt/share/users
fi

######################## AutoFS Configuration ########################

# Installation of AutoFS
apt-get install AutoFS

# Create a backup of the configuration file.
if [ ! -f /etc/auto.master.bak ]; then
    cp /etc/auto.master /etc/auto.master.bak
fi

# Create a backup of the configuration file.
if [ ! -f /etc/auto.nfs.bak ]; then
    cp /etc/auto.nfs /etc/auto.nfs.bak
fi

# Create the configuration file.
echo "/mnt/share    /etc/auto.nfs    --ghost,timeout=30" > /etc/auto.master

# Main AutoFS file.
echo  "users    -noexec,nosuid,rw,ghost    192.168.77.131:/srv/share/users" > /etc/auto.nfs

# Restart AutoFS.
/etc/init.d/autofs restart
