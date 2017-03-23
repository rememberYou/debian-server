#!/bin/bash

# Installation of ntp.
apt-get install ntp -y

# Installation of ntpdate.
apt-get install ntpdate -y

# Stop ntp.
systemctl stop ntp

# Adjust time server
ntpdate 1.be.pool.ntp.org

# Start ntp.
systemctl start ntp

# Create a backup of the configuration file.
cp /etc/ntp.conf /etc/ntp.bk

# Delete the initial configuration file.
#rm -f /etc/ntp.conf

# Create the configuration file.
echo "###### NTP CLIENT CONFIGURATION ######" > /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# Fichier contenant la deviation moyenne" >> /etc/ntp.conf
echo "driftfile /var/lib/ntp/ntp.drift" >> /etc/ntp.conf
echo " " >> /etc/ntp.conf

echo "# Statistiques desirees" >> /etc/ntp.conf
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


# Restart ntp.
systemctl restart ntp
