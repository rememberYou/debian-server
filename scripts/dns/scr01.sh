#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Creates an user.
function create_user() {
    useradd $username -m -G users -s /bin/bash
    echo -e "$password\n$password" | (passwd $username)
    smbpasswd -a tom
    create_website $username

    echo -e "$username user has been successfully added."
    echo -e "\t Quotas have been imposed on this user: "
    echo -e "The ${bold}www${normal} folder of the $username user has been succesfully created."
    echo -e "\t The index.html page was created."
}

# Deletes an user.
function delete_user() {
    deluser --remove-home $username users
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
    echo "zone $username IN {"
    echo "\t type master;"
    echo "\t file VH_$username.net.fwd;"
    echo "\t allow-query { any };"
    echo "};"
}

function create_file_dns() {
    echo "$TTL 1D" >>
    echo "@ IN SOA ns1.$username.be. admin.$username.be. {"
    echo -e "\t 0 ; serial"
    echo -e "\t 1D ; refresh"
    echo -e "\t 1H ; refresh"
    echo -e "\t 1W ; refresh"
    echo -e "\t 3H ) ; refresh"
    echo "}"
    echo ""
    echo "IN NS ns1.$username.be. ; name server"
    echo "www IN A <IP_SERVER>. ; Link to www.$username.be"
    echo "@ IN A <IP_SERVER> ; Link to www.$username.be"
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
