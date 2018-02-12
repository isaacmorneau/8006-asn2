#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi
read -p "Enter IP to test: " IP
nmap -Pr -oG -p 32768-32775,137-139,111,515 $IP
