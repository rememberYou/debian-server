#!/bin/bash

# Installation of SSH.
apt-get install ssh -y

######################## SSH Configuration ########################

echo -e "Enter your email address: "
read email

# Create the configuration file.
echo "###### SSH CLIENT CONFIGURATION ######" > ~/.ssh/ssh-conf
echo " " >> ~/.ssh/ssh-conf

echo "# Create the RSA Key Pair" >> ~/.ssh/ssh-conf
echo "ssh-keygen -t rsa -b 4096 -C $username" >> ~/.ssh/ssh-conf
echo " " >> ~/.ssh/ssh-conf

echo -e "\n"
