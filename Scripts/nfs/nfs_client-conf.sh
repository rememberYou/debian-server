#!/bin/bash

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
