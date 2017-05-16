#!/bin/bash

# Check the connectivity of the machine
ping -c 5 www.google.be

# Check the forward zone
dig www.google.be

# Ckeck the reverse zone
dig -x 10.1.254.254
