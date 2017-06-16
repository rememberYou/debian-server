#!/bin/bash

# SEE: https://wiki.debian.org/fr/vsftpd
#      https://doc.ubuntu-fr.org/vsftpd

# Installation of vsftpd.
apt-get install vsftpd -y

# Create a special user for 'ftp'
useradd --system ftp

# Optional : check that the server server boot and listenning to
# the TCP port by default (you should see vsftpd as "Program name").
netstat -npl

# Stop the VsFTPd daemon for the configuration.
/etc/init.d/vsftpd stop

# Create a backup of the main configuration file.
if [ ! -f /etc/vsftpd.bak ]; then
    cp /etc/vsftpd.conf /etc/vsftpd.bak
fi

# Create the configuration file.
echo "################ VSFTPD CONFIGURATION ################" > /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Set vsftpd in standalone mode." >> /etc/vsftpd.conf
echo "listen=YES" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Block the not allowed users." >> /etc/vsftpd.conf
echo "anonymous_enable=NO" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Allow the local connections" >> /etc/vsftpd.conf
echo "local_enable=YES" >> /etc/vsftpd.conf
echo "write_enable=YES" >> /etc/vsftpd.conf
echo "local_umask=022" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Allow connection for guests users." >> /etc/vsftpd.conf
echo "guest_enable=YES" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Default user for connections." >> /etc/vsftpd.conf
echo "guest_username=apache" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Avoid local users go to /root." >> /etc/ftpd.conf
echo "chroot_local_user=YES" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Send virtual users into the default folder."  >> /etc/vsftpd.conf
echo "local_root=/srv/www/" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# PAM manages the authentifications of the system." >> /etc/vsftpd.conf
echo "# We can set a login and a password to all the systems." >> /etc/vsftpd.conf
echo "pam_service_name=vsftpd" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Create a default folder for users." >> /etc/vsftpd.conf
echo "user_config_dir=/etc/vsftpd/vsftpd_conf_users" >> /etc/vsftpd.conf

# Create a folder for the configuration of VsFTPD
if [[ ! -d /mnt/incremental ]]; then
    mkdir /etc/vsftpd
fi

# Change the number of port to transmit:
listen_port=52152

# Basic monitoring
setproctitle_enable=YES

# To have the list of users connected on the FTP
# ps -aef | grep vsftd

# Or... you can follow the connections
# watch -n 1 'ps ax | grep vsftpd | grep -v grep'

# tail -f /var/log/vsftpd.log

# Restart the VsFTPd daemon.
/etc/init.d/vsftpd restart
