#!/bin/bash

if [ -d "/srv/web/$1" ]; then
    # Create users database.
    echo $1 >> /etc/vsftpd/login.txt
    echo $2 >> /etc/vsftpd/login.txt

    # Hash the database.
    db_load -T -t hash -f /etc/vsftpd/login.txt /etc/vsftpd/login.db

    # Set the rights for login files.
    chmod 600 /etc/vsftpd/login.*

    # Create the vsftpd file for the user.
    echo "################ USER VSFTPD FILE ################" >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo " " >> "/etc/vsftpd/vsftpd_conf_users/$1"

    echo "# Create the local folder of the user." >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo "local_root=/srv/web/$1" >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo " " >> "/etc/vsftpd/vsftpd_conf_users/$1"

    echo "# Allow anonymous users to not only read." >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo "anon_world_readable_only=NO" >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo " " >> "/etc/vsftpd/vsftpd_conf_users/$1"

    echo "# Allow anonymous users to write." >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo "write_enable=YES" >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo " " >> "/etc/vsftpd/vsftpd_conf_users/$1"

    echo "# Allow anonymous users to upload." >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo "anon_upload_enable=YES" >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo " " >> "/etc/vsftpd/vsftpd_conf_users/$1"

    echo "# Allow anonymous users to create folders." >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo "anon_mkdir_write_enablee=YES" >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo " " >> "/etc/vsftpd/vsftpd_conf_users/$1"

    echo "# Allow users to do other things than writing."
    echo "anon_other_write_enablee=YES" >> "/etc/vsftpd/vsftpd_conf_users/$1"
    echo " " >> "/etc/vsftpd/vsftpd_conf_users/$1"

    # Create the user folder.
    mkdir "/srv/web/$1"

    # Set apache as owner for all the files of user $1
    chown -R apache:apache "/srv/web/$1"

    # Restart vsftpd.
    service vsftpd start
fi
