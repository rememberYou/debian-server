#!/bin/bash

# Installation of NFS.
apt-get install nfs-kernel-server nfs-common

# Create a backup of the configuration file.
if [ ! -f /etc/exports.bk ]; then
    cp /etc/exports /etc/exports.bk
fi

# Create the sharing directory.
mkdir /srv/nfs

# Create the configuration file.
echo "###### NFS SERVER CONFIGURATION ######" > /etc/exports
echo " " >> /etc/exports

echo "/srv/nfs	10.1.0.0/16(rw,root_squash,no_subtree_check)" >> /etc/exportfs

# Update the table of exported file systems.
exports -a

# Restart NFS.
/etc/init.d/nfs-kernel-server reload
