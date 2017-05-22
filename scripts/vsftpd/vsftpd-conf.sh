#!/bin/bash

# Installation of vsftpd.
apt-get install vsftpd -y

# Enable vsftpd at startup.
systemctl enable vsftpd

# Start vsftpd.
systemctl start vsftpd

# Create a backup of the main configuration file.
cp /etc/vsftpd.conf /etc/vsftpd.bak
n
# Delete the initial configuration file.
rm -f /etc/vsftpd.conf

# Create the vsftpd folder.
mkdir /etc/vsftpd

# Create the web folder.
mkdir /srv/web

# Create the configuration file.
echo "################ VSFTPD CONFIGURATION ################" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Set vsftpd in standalone mode." >> /etc/vsftpd.conf
echo "listen=YES" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Block the not allowed users." >> /etc/vsftpd.conf
echo "anonymous_enable=NO" >> /etc/vsftpd.conf
echo " " >> /etc/vsftpd.conf

echo "# Allow the local connections" >> /etc/vsftpd.conf
echo "local_enable=YES" >> /etc/vsftpd.conf
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

# Restart vsftpd.
systemctl restart vsftpd
