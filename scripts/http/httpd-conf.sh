#!/bin/bash

echo "" >> "/etc/apache2/sites-available/$1.com.conf"

echo "<VirtualHost 10.1.215.223:80>" >> "/etc/apache2/sites-available/$1.com.conf"
echo "     ServerAdmin $1@$1.com" >> "/etc/apache2/sites-available/$1.com.conf"
echo "     ServerName $1@$1.com" >> "/etc/apache2/sites-available/$1.com.conf"
echo "     ServerAlias www.$1.com" >> "/etc/apache2/sites-available/$1.com.conf"
echo "     DocumentRoot \"/srv/web/$1/www\"" >> "/etc/apache2/sites-available/$1.com.conf"
echo "     ErrorLog ${APACHE_LOG_DIR}/error.log" >> "/etc/apache2/sites-available/$1.com.conf"
echo "     CustomLog ${APACHE_LOG_DIR}/access.log combined" >> "/etc/apache2/sites-available/$1.com.conf"
echo "</VirtualHost>"

#<Directory "srv/web/$1/www">
#</Directory>
