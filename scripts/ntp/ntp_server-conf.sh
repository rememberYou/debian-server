#!/bin/bash

# Installation of ntp.
apt-get install ntp -y

# Installation of ntpdate.
apt-get install ntpdate -y

# Stop ntp.
systemctl stop ntp

# Adjust time server
ntpdate 1.be.pool.ntp.org

# Create a backup of the configuration file.
if [ ! -f /etc/exports.bak ]; then
    cp /etc/ntp.conf /etc/ntp.bak
fi

# Create the configuration file.
echo "###### NTP SERVER CONFIGURATION ######" > /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "driftfile /var/lib/ntp/ntp.drift" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# Statistics loopstats peerstats clockstats" >> /etc/ntp.conf
echo "filegen loopstats file loopstats type day enable" >> /etc/ntp.conf
echo "filegen peerstats file peerstats type day enable" >> /etc/ntp.conf
echo "filegen clockstats file clockstats type day enable" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# You do need to talk to an NTP server or two (or three)." >> /etc/ntp.conf
echo "server 1.be.pool.ntp.org iburst" >> /etc/ntp.conf
echo "server 3.europe.pool.ntp.org" >> /etc/ntp.conf
echo "server 2.europe.pool.ntp.org" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# By default, exchange time with everybody, but don't allow configuration." >> /etc/ntp.conf
echo "restrict -4 default kod notrap nomodify nopeer noquery" >> /etc/ntp.conf
echo "restrict -6 default kod notrap nomodify nopeer noquery" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# Local users may interrogate the ntp server more closely." >> /etc/ntp.conf
echo "restrict 127.0.0.1" >> /etc/ntp.conf
echo "restrict 10.1.0.0 mask 255.255.0.0 nomodify notrap nopeer" >> /etc/ntp.conf
echo "restrict ::1" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# To provide time to the local subnet." >> /etc/ntp.conf
echo "broadcast 10.1.255.255" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

# Restart ntp.
systemctl restart ntp
