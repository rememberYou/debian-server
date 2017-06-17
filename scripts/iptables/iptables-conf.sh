#!/bin/bash

# SEE
# http://www.thegeekstuff.com/scripts/iptables-rules
# https://www.cyberciti.biz/faq/centos-ssh/
#
# Use "rpcinfo -p" to know which ports to block/allow

# Flushing all rules from all tables.
iptables -F ; iptables -X
iptables -t nat -F ; iptables -t nat -X
iptables -t mangle -F ; iptables -t mangle -X
iptables -t raw -F ; iptables -t raw -X

# Setting default filter policy.
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow loopback access.
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Ping from inside to outside.
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

# Ping from outside to inside.
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Allow DNS (53)
iptables -A OUTPUT -p udp -o eth0 --dport 53 -j ACCEPT
iptables -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT

# Allow incoming HTTP (80) and HTTPS (443).
iptables -A INPUT -i eth0 -p tcp -m multiport --dports 80,443 \
	 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 80,443 \
	 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming SSH (62000).
iptables -A INPUT -i eth0 -p tcp --dport 62000 \
         -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 62000 \
         -m state --state ESTABLISHED -j ACCEPT

# Allow outgoing SSH (62000).
iptables -A OUTPUT -o eth0 -p tcp --dport 62000 \
         -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 62000 \
         -m state --state ESTABLISHED -j ACCEPT

# Allow outcoming NTP (123).
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p udp --sport 123 -j ACCEPT

# Allow incoming NTP (123).
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp --sport 123 -j ACCEPT

# Allow incomming NFS.
iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m multiport --dports 111,2049,36089,43008,43301,48232,50277 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p udp -m multiport --dports 111,2049,33111,42714,43880,46765,55770 -m state --state NEW,ESTABLISHED -j ACCEPT

# Allow outgoing NFS.
iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m multiport --sports 111,2049,36089,43008,43301,48232,50277 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p udp -m multiport --sports 111,2049,33111,42714,43880,46765,55770 -m state --state ESTABLISHED -j ACCEPT

#Samba
iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.0/24 -j ACCEPT
iptables -A FORWARD -s 192.168.1.0/24 -j ACCEPT

# Allow incoming Samba (UDP: 137,138 | TCP: 139,445)
iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p udp -m multiport --dport 137,138 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -d 192.168.1.0/24 -p tcp -m multiport --dport 139,445 -m state --state NEW,ESTABLISHED -j ACCEPT

# Allow outgoing Samba (UDP: 137,138 | TCP: 139,445)
iptables -A OUTPUT -d 192.168.1.0/24 -p udp -m multiport --dport 137,138 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -d 192.168.1.0/24 -p tcp -m multiport --dport 139,445 -m state --state ESTABLISHED -j ACCEPT
