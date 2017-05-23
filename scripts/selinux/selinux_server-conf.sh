#!/bin/bash

# SEE: https://wiki.debian.org/SELinux/Setup#policies

# [ NOTE: Don't try SELinux yet Alexandre, I'm just starting to configure it.
#         Also, don't run this script, it is more secure to do that by our
#         hands for beginning. ]

# Installation of SELinux.
apt-get install selinux-basics selinux-policy-default auditd

# Configure GRUB and PAM and to create /.autorelabel
selinux-activate

# Reboot the system.
reboot

# check that everything has been setup correctly and to catch common SELinux problems
check-selinux-installation

# You should now have a working SELinux system, which is in permissive mode.
# This means that the selinux policy is not enforced, but denials are logged.

# You can see all would-be denials since the last reboot.
audit2why -al

# If no critical audit errors appear in your syslog and you feel comfortable with
# SELinux, enable enforcing mode temporarily by running:
setenforce 1

# To enable enforcing mode permanently, you need to add it to the kernel command.
echo "enforcing=1" >> /etc/default/grub

# Reboot the system.
reboot

# Some of the PAM config files need to have "session required pam_selinux.so multiple"
# added, selinux-activate makes the necessary changes.

# The shadow package includes a daily cronjob to backup some system files, including /etc/shadow.
# For security reasons, you don't want cron to be able to read this file, so edit
# /etc/cron.daily/passwd and disable the part making a backup of /etc/shadow and /etc/gshadow.

# [ NOTE: We will need to see for disable locate and updatedb because it's damage the performance
#         of the server because the command 'find' is really better and if we want to use them,
#         we will need to configurate SELinux to allow them, because these commands will take a look
#         for the searched file, everywhere on the system. ]

# A regular user (depending on the policy) might not be able to do a "ping", unless you set the
# "user_ping" boolean.
