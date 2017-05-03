#!/bin/bash

# Install SSH.
apt-get install openssh-client -y

######################## SSH Configuration ########################

read -p "Enter your email address: " email

# Create the SSH configuration script file.
mkdir -p ~/.ssh/

# Create the RSA key pair.
ssh-keygen -t rsa -b 4096 -C $email -f "/$USER/.ssh/id_rsa" -N ""
