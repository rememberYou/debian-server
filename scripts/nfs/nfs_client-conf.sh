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
mount -t nfs 10.1.215.223:/srv/nfs /mnt/nfs

echo "# /etc/fstab: static file system information." >> /etc/fstab
echo "#" >> /etc/fstab
echo "# Use 'blkid' to print the universally unique identifier for a" >> /etc/fstab
echo "# device; this may be used with UUID= as a more robust way to name devices" >> /etc/fstab
echo "# that works even if disks are added and removed. See fstab(5)." >> /etc/fstab
echo "#"
echo "# <file system> <mount point>   <type>  <options>       <dump>  <pass>" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVroot /               ext4    errors=remount-ro 0       1" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVhome /home           ext4    defaults        0       2" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVopt /opt            ext4    defaults        0       2" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVsrv /srv            ext4    defaults        0       2" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVtmp /tmp            ext4    defaults        0       2" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVusr /usr            ext4    defaults        0       2" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVvar /var            ext4    defaults        0       2" >> /etc/fstab
echo "/dev/mapper/VolGroup-LVswap none            swap    sw              0       0" >> /etc/fstab
echo "/dev/sr0        /media/cdrom0   udf,iso9660 user,noauto     0       0" >> /etc/fstab
echo "10.1.215.223:/srv/nfs     /mnt/nfs     defaults        0       0" >> /etc/fstab

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
