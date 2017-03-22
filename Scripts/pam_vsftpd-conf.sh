#!/bin/bash

# Create a backup of the main configuration file.
cp /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bk

# Create the configuration file.
echo "################ PAM VSFTPD CONFIGURATION ################" >> /etc/pam.d/vsftpd
echo " " >> /etc/pam.d/vsftpd

echo "# Authentification"
echo "auth    required     /lib/x86_64-linux-gnu/security/pam_userdb.so    db=/etc/vsftpd/login" >> /etc/pam.d/vsftpd
echo "account    required    /lib64/security/pam_userdb.so db=/etc/vsftpd/login" >> /etc/pam.d/vsftpd

# Installation of db-util
apt-get install db-util -y

# Create the users configuration folder for vsftp.
mkdir /etc/vsftpd/vsftpd_conf_users

# Create users database through pam_user-conf.sh
./pam_user-conf.sh florian DiVrusa
./pam_user-conf.sh guillaume Quittet
