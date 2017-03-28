#!/bin/bash

# Ensure that your system’s package database is up to date and that
# all installed software is running at the latest version.
apt-get update
apt-get upgrade

# Import the GPG key so that APT can verify the integrity of the packages it download.
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db

echo "deb http://ftp.belnet.be/debian/ jessie main" >> /etc/apt/sources.list
echo "deb-src http://ftp.belnet.be/debian/ jessie main" >> /etc/apt/sources.list
echo " " >> /etc/apt/sources.list
echo "deb http://security.debian.org/ jessie/updates main contrib" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ jessie/updates main contrib" >> /etc/apt/sources.list
echo " " >> /etc/apt/sources.list
echo "# jessie-updates, previously known as \"volatile\"" >> /etc/apt/sources.list
echo "deb http://ftp.belnet.be/debian/ jessie-updates main contrib" >> /etc/apt/sources.list
echo "deb-src http://ftp.belnet.be/debian/ jessie-updates main contrib" >> /etc/apt/sources.list

# Retrieve the information APT needs to install MariaDB.
apt-get update

# Install MariaDB.
apt-get install mariadb-server
