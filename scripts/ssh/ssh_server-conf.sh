#!/bin/bash

# Installation of SSH.
apt-get install openssh-server -y

# Create a backup of the configuration file.
if [ ! -f /etc/ssh/sshd_config.bak ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
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

# Create the banner.
mkdir -p /etc/ssh-banner/

echo -e "
  **************************************************************************************
  *   The debianThink server is for authorized personnel only.                         *
  *   WARNING! Access to this device is restricted to those individuals with specific  *
  *   permissions. If you are not an authorized user, disconnect now.                  *
  *   Any attempts to gain unauthorized access will be prosecuted to                   *
  *   the fullest extent of the law.                                                   *
  *                                                                                    *
  *   All access and use may (not will) be monitored and/or recorded.                  *
  **************************************************************************************
  " > /etc/ssh-banner/banner

# Restart SSH.
systemctl restart sshd
