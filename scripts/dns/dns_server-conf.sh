#!/bin/bash

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
    apt-get install bind9 bind9utils bind9-doc -y

    create_acl_group

    echo "" >> "/etc/bind/named.conf.options"

    echo "options {" >> "/etc/bind/named.conf.options"
    echo "        directory \"/var/cache/bind\";" >> "/etc/bind/named.conf.options"

    echo "" >> "/etc/bind/named.conf.options"

    echo "        recursion yes;" >> "/etc/bind/named.conf.options"
    echo "        allow-query { goodclients; };" >> "/etc/bind/named.conf.options"

    echo "" >> "/etc/bind/named.conf.options"

    echo "        forwarders {" >> "/etc/bind/named.conf.options"
    echo "                8.8.8.8;" >> "/etc/bind/named.conf.options"
    echo "                8.8.4.4;" >> "/etc/bind/named.conf.options"
    echo "        };" >> "/etc/bind/named.conf.options"
    echo "        forward only;" >> "/etc/bind/named.conf.options"

    echo "" >> "/etc/bind/named.conf.options"

    echo "        dnssec-enable yes;" >> "/etc/bind/named.conf.options"
    echo "        dnssec-validation yes;" >> "/etc/bind/named.conf.options"

    echo "" >> "/etc/bind/named.conf.options"

    echo "        # Conform to RFC1035" >> "/etc/bind/named.conf.options"
    echo "        auth-nxdomain no;" >> "/etc/bind/named.conf.options"
    echo "        listen-on-v6 { any; };" >> "/etc/bind/named.conf.options"
    echo "};" >> "/etc/bind/named.conf.options"

    systemctl restart bind9
}

create_dns
