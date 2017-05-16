#!/bin/bash

# Verify the configuration file
named-checkconf

# Get DNS server log
journalctl -u bind9 -f
