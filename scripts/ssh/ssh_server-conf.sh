#!/bin/bash

# Installation of SSH.
apt-get install ssh -y

# Create a backup of the configuration file.
if [ ! -f /etc/ssh/sshd_config.bk ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bk
fi

######################## SSH Configuration ########################

# Create the configuration file.
echo "###### SSH SERVER CONFIGURATION ######" > /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Using port number 62000" >> /etc/ssh/sshd_config
echo "Port 62000" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Using Protocol 2 of SSH" >> /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Private Host Key for Authentication" >> /etc/ssh/sshd_config
echo "HostKey /etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Privilege separation for security" >> /etc/ssh/sshd_config
echo "UsePrivilegeSeparation yes" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Size of the server key and its lifetime" >> /etc/ssh/sshd_config
echo "ServerKeyBits 4096" >> /etc/ssh/sshd_config
echo "KeyRegenerationInterval 3600" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Deactivation of the login in root and disconnection after 120 seconds if no connections" >> /etc/ssh/sshd_config
echo "LoginGraceTime 120" >> /etc/ssh/sshd_config
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
echo "StrictModes yes" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Enabling RSA Authentication" >> /etc/ssh/sshd_config
echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile        %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# We do not read the Rhosts user files" >> /etc/ssh/sshd_config
echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config
echo "RhostsRSAAuthentication no" >> /etc/ssh/sshd_config
echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# We deny the authentication by MDP (because we have the RSA keys)" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo " " >> /etc/ssh/sshd_config

echo "# Placement of the banner" >> /etc/ssh/sshd_config
echo "Banner /etc/ssh-banner/banner" >> /etc/ssh/sshd_config

# Restart SSH.
systemctl restart sshd
