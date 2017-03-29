#!/bin/bash

# SEE: https://www.howtoforge.com/tutorial/debian-samba-server/

# Installation of Samba.
apt-get install libcups2 samba samba-common cups

# Create a backup of the configuration file.
if [ ! -f /etc/samba/smb.conf.bak ]; then
    cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
fi

# Create the configuration file.
#
# If you don't know the name of the workgroup
# run this command on the Windows client to get
# the workgroup name: net config workstation.
echo "[global]" > /etc/samba/smb.conf
echo "workgroup = WORKGROUP" >> /etc/samba/smb.conf
echo "server string = Samba Server %v" >> /etc/samba/smb.conf
echo "netbios name = debian" >> /etc/samba/smb.conf
echo "security = user" >> /etc/samba/smb.conf
echo "map to guest = bad user" >> /etc/samba/smb.conf
echo "dns proxy = no" >> /etc/samba/smb.conf

mkdir -p /srv/samba
chown -R root:users /srv/samba/users/
chmod -R 775 /srv/samba/users/

# Share that is accessible and writable for all members of "users" group.
echo " " >> /etc/samba/smb.conf
echo "[users]" >> /etc/samba/smb.conf
echo "comment = All Users" >> /etc/samba/smb.conf
echo "path = /srv/samba/users" >> /etc/samba/smb.conf
echo "valid users = @users" >> /etc/samba/smb.conf
echo "force group = users" >> /etc/samba/smb.conf
echo "create mask = 0660" >> /etc/samba/smb.conf
echo "directory mask = 0771" >> /etc/samba/smb.conf
echo "writable = yes" >> /etc/samba/smb.conf
echo " " >> /etc/samba/smb.conf

# Share that make able users to read and write to their home directories.
echo "[homes]" >> /etc/samba/smb.conf
echo "comment = Home Directories" >> /etc/samba/smb.conf
echo "browseable = no" >> /etc/samba/smb.conf
echo "valid users = %S" >> /etc/samba/smb.conf
echo "writable = yes" >> /etc/samba/smb.conf
echo "create mask = 0700" >> /etc/samba/smb.conf
echo "directory mask = 0700" >> /etc/samba/smb.conf

# Restart Samba.
systemctl restart smbd.service
