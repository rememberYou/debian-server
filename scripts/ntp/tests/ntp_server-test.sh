#!/bin/bash

# Restart ntp
systemctl restart ntp

# Synchronize the time from the server.
ntpq -p
