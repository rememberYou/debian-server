#!/bin/bash

# Set a date.
date -s 23:05:42

# Restart ntp
systemctl restart ntp

# Synchronize the time from the server.
# To do manually
#ntpq -p
