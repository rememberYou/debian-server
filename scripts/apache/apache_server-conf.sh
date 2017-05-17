#!/bin/bash

# See: https://www.linode.com/docs/web-servers/apache/apache-web-server-debian-8

# Be careful to launch the script before create the users.

# Configure the Multi-Processing Module
function configure_multi_processing() {
    # Create a backup of the configuration file.
    if [ ! -f /etc/apache2/mods-available/mpm_prefork.conf.bak ]; then
	cp /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf.bak
    fi

    echo "# prefork MPM" > /etc/apache2/mods-available/mpm_prefork.conf
    echo "# StartServers: number of server processes to start" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "# MinSpareServers: minimum number of server processes which are kept spare" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "# MaxSpareServers: maximum number of server processes which are kept spare" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "# MaxRequestWorkers: maximum number of server processes allowed to start" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "# MaxConnectionsPerChild: maximum number of requests a server process serves" >> /etc/apache2/mods-available/mpm_prefork.conf

    echo "" >> /etc/apache2/mods-available/mpm_prefork.conf

    echo "<IfModule mpm_prefork_module>" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "        StartServers               4"  >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "        MinSpareServers            20" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "        MaxSpareServers            40" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "        MaxRequestWorkers          200" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "        MaxConnectionsPerChild     4500" >> /etc/apache2/mods-available/mpm_prefork.conf
    echo "</IfModule>" >> /etc/apache2/mods-available/mpm_prefork.conf
}

function min_info() {
    if [ grep -Fxq "ServerTokens ProductOnly" "/etc/apache2/apache2.conf" ]; then
	echo "ServerTokens ProductOnly" >> /etc/apache2/apache2.conf
	echo "ServerSignature Off" >> /etc/apache2/apache2.conf
    fi
}

# Configure the Multi-Processing Module
function configure_event_module() {
    # Create a backup of the configuration file.
    if [ ! -f /etc/apache2/mods-available/mpm_event.conf.bak ]; then
	cp /etc/apache2/mods-available/mpm_event.conf /etc/apache2/mods-available/mpm_event.conf.bak
    fi

    echo "# event MPM" > /etc/apache2/mods-available/mpm_event.conf
    echo "# StartServers: initial number of server processes to start" >> /etc/apache2/mods-available/mpm_event.conf
    echo "# MinSpareThreads: minimum number of worker threads which are kept spare" >> >> /etc/apache2/mods-available/mpm_event.conf
    echo "# MaxSpareThreads: maximum number of worker threads which are kept spare" >> /etc/apache2/mods-available/mpm_event.conf
    echo "# ThreadsPerChild: constant number of worker threads in each server process" >> /etc/apache2/mods-available/mpm_event.conf
    echo "# MaxRequestWorkers: maximum number of worker threads" >> /etc/apache2/mods-available/mpm_event.conf
    echo "# MaxConnectionsPerChild: maximum number of requests a server process serves" >> /etc/apache2/mods-available/mpm_event.conf

    echo "" >> /etc/apache2/mods-available/mpm_prefork.conf

    echo "<IfModule mpm_event_module>" >> /etc/apache2/mods-available/mpm_event.conf
    echo "        StartServers               2"  >> /etc/apache2/mods-available/mpm_event.conf
    echo "        MinSpareThreads            25" >> /etc/apache2/mods-available/mpm_event.conf
    echo "        MaxSpareThreads            75" >> /etc/apache2/mods-available/mpm_event.conf
    echo "        ThreadLimit                64" >> /etc/apache2/mods-available/mpm_event.conf
    echo "        ThreadsPerChild            25" >> /etc/apache2/mods-available/mpm_event.conf
    echo "        MaxRequestWorkers          150" >> /etc/apache2/mods-available/mpm_event.conf
    echo "        MaxConnectionsPerChild     3O00" >> /etc/apache2/mods-available/mpm_event.conf
    echo "</IfModule>" >> /etc/apache2/mods-available/mpm_event.conf
}

# Configure Apache for Virtual Hosting
function configure_apache() {
    # Disable the default Apache virtual host.
    sudo a2dissite 000-default.conf

    echo "<VirtualHost *:80>" > /etc/apache2/sites-available/example.lan.conf
    echo "     ServerAdmin webmaster@example.lan" >> /etc/apache2/sites-available/example.lan.conf
    echo "     ServerName example.lan" >> /etc/apache2/sites-available/example.lan.conf
    echo "     ServerAlias www.example.lan" >> /etc/apache2/sites-available/example.lan.conf
    echo "     DocumentRoot /srv/web/example/www" >> /etc/apache2/sites-available/example.lan.conf
    echo "     ErrorLog /srv/web/example.lan/logs/error.log" >> /etc/apache2/sites-available/example.lan.conf
    echo "     CustomLog /srv/web/$username.lan/logs/access.log combined" >> /etc/apache2/sites-available/example.lan.conf
    echo "</VirtualHost>" >> /etc/apache2/sites-available/example.lan.confb
}

# Installation of Apache 2.
apt-get install apache2 apache2-doc apache2-utils -y

# If you choose to keep the event module enabled, these settings are suggested
# for a 2GB Linode.
configure_multi_processing

# On Debian 8, the event module is enabled by default. This will need to be
# disabled, and the prefork module enabled.
sudo a2dismod mpm_event
sudo a2enmod mpm_prefork

# Restart Apache.
sudo systemctl restart apache2

configure_event_module

# Restart Apache.
sudo systemctl restart apache2

# Configure Apache.
configure_apache

# Permit to not display the version of PHP for users.
min_info

# Create directories for the websites.
sudo mkdir -p /var/www/example.lan/public_html
# Create directories for the websites'logs.
sudo mkdir /var/www/example.lan/logs

# Enable the website.
sudo a2ensite example.lan.conf

# Restart Apache.
sudo systemctl restart apache2

# Install PHP support.
sudo apt-get install php5 php-pear -y
