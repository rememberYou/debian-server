#!/bin/bash

# Install SSH.
apt-get install openssh-client -y

######################## SSH Configuration ########################

echo -e "Enter your email address: "
read email

# Create the SSH configuration script file.
mkdir -p ~/.ssh/

# Create the RSA key pair.
ssh-keygen -t rsa -b 4096 -C $email

echo -e "\n"
