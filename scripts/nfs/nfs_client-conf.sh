#!/bin/bash

# Install NFS
apt-get install nfs-common

# Create the NFS directory
mkdir -p /mnt/nfs

# Mount the /srv/nfs directory from the <10.1.0.0> server to the /mnt/nfs
# directory of the client.
#
# Be careful to change the server IP address or/and the repository
# directory if needed.
mount -t nfs 10.1.215.223/16:/srv/nfs /mnt/nfs

# Mount the /srv/nfs directory for each boot of the client machine.
10.1.215.223:/srv/nfs  /mnt/nfs   nfs    soft,timeo=5,intr,rsize=8192,wsize=8192  0  0

# Restart NFS
/etc/init.d/nfs-kernel-server reload

######################## AutoFS Configuration ########################

# Installation of AutoFS
apt-get install AutoFS

# Create the configuration file.
echo "/srv/    /etc/auto.nfs    --timeout=2,sync,nodev,nosuid" >> /etc/auto.master

# Main AutoFS file.
echo  "nfs    -fstype=nfs,rw,inter    10.1.215.223:/srv/nfs" >> /etc/auto.nfs

# Restart AutoFS.
/etc/init.d/autofs restart
