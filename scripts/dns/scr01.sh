#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Creates an user.
function create_user() {
    useradd -m -g users -s /bin/bash $username
    echo -e "$password\n$password" | (passwd $username)
    create_website $username

    echo -e "$username user has been successfully added."
    echo -e "\t Quotas have been imposed on this user: "
    echo -e "The ${bold}www${normal} folder of the $username user has been succesfully created."
    echo -e "\t The index.html page was created."
}

# Deletes an user.
function delete_user() {
    userdel $username
    rm -r /home/$username
}

# Creates a website for a specific user.
function create_website() {
    echo "<VirtualHost *:80>" >> "/etc/apache2/sites-enabled/$username.conf"
    echo -e "\tServerAdmin $username@$username.lan" >> "/etc/apache2/sites-enabled/$username.conf"
    echo -e "\tDocumentRoot /srv/web/$username/www" >> "/etc/apache2/sites-enabled/$username.conf"
    echo -e "\tServerName www.$username.lan" >> "/etc/apache2/sites-enabled/$username.conf"
    echo "</VirtualHost>" >> "/etc/apache2/sites-enabled/$username.conf"
}

# Creates a DNS for a specific user.
function create_dns() {
    echo "$username IN {"
    echo "\t type master;"
    echo "\t file VH_$username.be;"
    echo "};"
}

echo -e "Enter the name of the website (without the www): "
read username
echo -e "Enter the password associted with this account: "
read password

create_user $username $password
echo -e "$name user has been successfully added."
echo -e "\t Quotas have been imposed on this user: "
echo -e "The ${bold}www${normal} folder of the $name user has been succesfully created."
echo -e "\t The index.html page was created."

echo -e "Starting the Apache service..."
#/etc/init.d/apache2 start

echo -e "Virtual Host has been successfully create."
echo -e "Starting the BIND service...."
echo -e "Loading named:"
echo -e "The site is now available at the following address: "