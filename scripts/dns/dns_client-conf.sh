#!/bin/bash

# Create a backup of the configuration file.
if [ ! -f /etc/bind/named.conf.options.bak ]; then
    cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak
fi

echo "# This file describes the network interfaces available on your system" > /etc/network/interfaces
echo "# and how to activate them. For more information, see interfaces(5)." >> /etc/network/interfaces

echo "" >> /etc/network/interfaces

echo "echosource /etc/network/interfaces.d/*" >> /etc/network/interfaces

echo "# The loopback network interface" >> /etc/network/interfaces
echo "allow-hotplug eth0" >> /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address      10.1.214.185" >> /etc/network/interfaces
echo "netmask      255.255.0.0" >> /etc/network/interfaces
echo "gateway      10.1.254.254" >> /etc/network/interfaces
echo "dns-namerver 192.0.2.2" >> /etc/network/interfaces
