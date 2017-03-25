#!/bin/bash

# Installation of NTP.
apt-get install ntp -y

# Installation of ntpdate.
apt-get install ntpdate -y

# Stop NTP.
systemctl stop ntp

# Adjust time server
ntpdate 1.be.pool.ntp.org

# Start NTP.
systemctl start ntp

# Create a backup of the configuration file.
cp /etc/ntp.conf /etc/ntp.bk

# Create the configuration file.
echo "###### NTP CLIENT CONFIGURATION ######" > /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# File containing the average deviation." >> /etc/ntp.conf
echo "driftfile /var/lib/ntp/ntp.drift" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# Desired Statistics" >> /etc/ntp.conf
echo "statistics loopstats peerstats clockstats" >> /etc/ntp.conf
echo "filegen loopstats file loopstats type day enable" >> /etc/ntp.conf
echo "filegen peerstats file peerstats type day enable" >> /etc/ntp.conf
echo "filegen clockstats file clockstats type day enable" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# You do need to talk to an NTP server or two (or three)." >> /etc/ntp.conf
echo "server 10.1.214.184 prefer" >> /etc/ntp.conf
echo "server 1.be.pool.ntp.org iburst" >> /etc/ntp.conf
echo "server 3.europe.pool.ntp.org" >> /etc/ntp.conf
echo "server 2.europe.pool.ntp.org" >> /etc/ntp.conf

# Restart NTP.
systemctl restart ntp
