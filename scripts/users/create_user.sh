#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Creates an user.
function create_user() {
    useradd $username -m -G users -s /bin/bash
    echo -e "$password\n$password" | (passwd $username)

    quotatool -u $username -bq 400M -l 500M /home
    #quotatool -u $username -bq 400M -l 500M /srv/share

    smbpasswd -a $username

    # Each created users, will have their own database to avoid that one user
    # can have access to every databases.
    create database $username;
    grant usage on *.* to $username@localhost identified by $username;
    grant all privileges on $username.* to $username@localhost;

    # Now you can connect to the database of the user with the following
    # command:  mysql -u $username -p $password $username

    create_website $username
}

# Creates a website for a specific user.
function create_website() {
    echo "<VirtualHost *:80>" > "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerAdmin $username@$username.lan" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerName $username.lan" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerAlias www.$username.lan" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tDocumentRoot /srv/www/$username/www" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tErrorLog /srv/www/$username.lan/logs/error.log" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tCustomLog /srv/www/$username.lan/logs/access.log combined" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo "</VirtualHost>" >> "/etc/apache2/sites-enabled/$username.lan.conf"

    mkdir -p "/srv/www/$username/www"
}

echo -e "Enter the name of the user: "
read username
if id "$username" >/dev/null 2>&1; then
    echo "user already exists!"
else
    echo -e "Enter the password associted with this account: "
    read password

    create_user $username $password

    echo -e "$username user has been successfully added."
    echo -e "The ${bold}www${normal} folder of the $username user has been succesfully created."
    echo -e "\t The index.html page was created."
fi
