#!/bin/bash

echo "" >> "/etc/apache2/sites-enabled/$1.conf"

<VirtualHost 10.1.215.223:80>
ServerAdmin "$1@$1.lan"
DocumentRoot "/srv/web/$1/www"
ServerName "www.$1.lan"
ErrorLog ${APACHE_LOG_DIR}/error.log
ErrorLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
<Directory "srv/web/$1/www">
</Directory>
