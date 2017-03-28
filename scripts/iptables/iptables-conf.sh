#!/bin/bash

# SEE
# http://www.thegeekstuff.com/scripts/iptables-rules
# https://www.cyberciti.biz/faq/centos-ssh/

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

# Allow incoming SSH (22).
iptables -A INPUT -i eth0 -p tcp --dport 22 \
         -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 22 \
         -m state --state ESTABLISHED -j ACCEP

# Allow outgoing SSH (22).
iptables -A OUTPUT -o eth0 -p tcp --dport 22 \
         -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 22 \
         -m state --state ESTABLISHED -j ACCEPT

# Allow outcoming NTP (123)
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p udp --sport 123 -j ACCEPT

# Allow incoming NTP (123)
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp --sport 123 -j ACCEPT
