#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Creates an user.
function create_user() {
    useradd $username -m -G users -s /bin/bash
    echo -e "$password\n$password" | (passwd $username)
    smbpasswd -a $username
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

# Creates a Cache DNS
function create_cache_dns() {
    
}

# Creates the ACL of clients that we want to resolve request
# to avoid the DNS amplification attack.
function create_acl_group() {
    apt-get install bind9 bind9utils bind9-doc -y
    
    # Create a backup of the configuration file.
    if [ ! -f /etc/bind/named.conf.options.bak ]; then
        cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak
    fi
    
    echo "acl goodclients {" > "/etc/bind/named.conf.options"
    echo "        10.1.0.0/16;" >> "/etc/bind/named.conf.options"
    echo "        localhost;" >> "/etc/bind/named.conf.options"
    echo "        localnets;" >> "/etc/bind/named.conf.options"
    echo "};" >> "/etc/bind/named.conf.options" 
}

# Creates a Cache and Forward DNS
function create_dns() {
    echo "" >> "/etc/bind/named.conf.options"
    
    echo "options {" >> "/etc/bind/named.conf.options"
    echo "        directory /var/cache/bind;" >> "/etc/bind/named.conf.options"
    
    echo "" >> "/etc/bind/named.conf.options"
    
    echo "        recursion yes;" >> "/etc/bind/named.conf.options"
    echo "        allow-query { goodclients; };" >> "/etc/bind/named.conf.options"
    
    echo "" >> "/etc/bind/named.conf.options"
    
    echo "        forwarders {" >> "/etc/bind/named.conf.options"
    echo "                8.8.8.8;" >> "/etc/bind/named.conf.options"
    echo "                8.8.4.4;" >> "/etc/bind/named.conf.options"
    echo "        };" >> "/etc/bind/named.conf.options"
    echo "        forward onlny" >> "/etc/bind/named.conf.options"

    echo "" >> "/etc/bind/named.conf.options"
    
    echo "        dnssec-enable yes" >> "/etc/bind/named.conf.options"
    echo "        dnssec-validation yes;" >> "/etc/bind/named.conf.options"
    
    echo "" >> "/etc/bind/named.conf.options"
    
    echo "        dnssec-validation auto;" >> "/etc/bind/named.conf.options"

    echo "" >> "/etc/bind/named.conf.options"
    
    echo "        # Conform to RFC1035" >> "/etc/bind/named.conf.options"
    echo "        auth-nxdomain no;" >> "/etc/bind/named.conf.options"
    echo "        listen-on-v6 { any; };" >> "/etc/bind/named.conf.options"
    echo "};" >> "/etc/bind/named.conf.options"

    #   mkdir /var/log/bind9
    #    chown bind:bind /var/log/bind9    

    # Create a backup of the configuration file.
    #   if [ ! -f /etc/bind/named.conf.bak ]; then
    #	cp /etc/bind/named.conf /etc/bind/named.conf.bak
	# fi

	# echo "zone $username {" > "/etc/bind/zones/$username.conf";
    # echo -e "\t type master;" >> "/etc/bind/zones/$username.conf";
    # echo -e "\t file \" /etc/bind/zones/$username.db" >> "/etc/bind/zones/$username.conf";
    # echo "};" >> "/etc/bind/zones/$username.conf";
}

function create_file_dns() {
    echo "$TTL    86400" > "/etc/bind/zones/$username.db";
    echo "@   IN  SOA ns1.$username.com. root.$username.com. (" >> "/etc/bind/zones/$username.db";
    echo "        2014100801  ; Serial" >> "/etc/bind/zones/$username.db";
    echo "        43200       ; Refresh" >> "/etc/bind/zones/$username.db";
    echo "        3600        ; Retry" >> "/etc/bind/zones/$username.db";
    echo "        1209600     ; Expire" >> "/etc/bind/zones/$username.db";
    echo "        180 )       ; Minimum TTL" >> "/etc/bind/zones/$username.db";

    echo " " >>  "/etc/bind/zones/$username.db";
    echo "; Nameservers" >> "/etc/bind/zones/$username.db";
    echo "IN  NS  ns1.$username.com." >> "/etc/bind/zones/$username.db";

    echo " " >>  "/etc/bind/zones/$username.db";
    echo "; Root site" >>  "/etc/bind/zones/$username.db";
    echo "IN  A   192.168.30.161" >>  "/etc/bind/zones/$username.db";

    echo " " >>  "/etc/bind/zones/$username.db";
    echo "; Hostname records" >>  "/etc/bind/zones/$username.db";
    echo "*   IN  A   192.168.30.161" >>  "/etc/bind/zones/$username.db";

    echo " " >>  "/etc/bind/zones/$username.db";
    echo "; Aliases" >>  "/etc/bind/zones/$username.db";
    echo "www IN  CNAME   $username.com." >>  "/etc/bind/zones/$username.db";

    echo " " >>  "/etc/bind/zones/$username.db";
    echo "; MX records" >>  "/etc/bind/zones/$username.db";
    echo "@   IN  MX  1   aspmx.l.google.com." >>  "/etc/bind/zones/$username.db";
}

echo -e "Enter the name of the website (without the www): "
read username
if id "$username" >/dev/null 2>&1; then
    echo "user already exists!"
else
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
    echo -e "The site is now available at the following address: www.$username.lan"
fi
