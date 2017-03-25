#!/bin/bash

# Installation of NFS.
apt-get install nfs-kernel-server nfs-common

# Create a backup of the configuration file.
cp /etc/exports /etc/exports.bk

# Create the sharing directory.
mkdir /srv/nfs

# Create the configuration file.
echo "###### NFS SERVER CONFIGURATION ######" > /etc/exports
echo " " >> /etc/exports

echo "/srv/nfs	10.1.0.0/16(rw,root_squash)"

# Restart NFS.
/etc/init.d/nfs-kernel-server reload
