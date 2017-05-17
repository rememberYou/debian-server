#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Creates an user.
function create_user() {
    useradd $username -m -G users -s /bin/bash
    echo -e "$password\n$password" | (passwd $username)

    smbpasswd -a $username

    create_website $username
}

# Creates a website for a specific user.
function create_website() {
    echo "<VirtualHost *:80>" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerAdmin $username@$username.lan" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tServerName $username.lan" >> "/etc/apache2/sites-available/$username.lan.conf"
    echo -e "\tServerAlias www.$username.lan" >> "/etc/apache2/sites-available/$username.lan.conf"
    echo -e "\tDocumentRoot /srv/web/$username/www" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tErrorLog /srv/web/$username.lan/logs/error.log" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo -e "\tCustomLog /srv/web/$username.lan/logs/access.log combined" >> "/etc/apache2/sites-enabled/$username.lan.conf"
    echo "</VirtualHost>" >> "/etc/apache2/sites-enabled/$username.conf"
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
