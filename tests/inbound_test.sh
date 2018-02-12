#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi
read -p "Enter firewall IP: " IP
read -p "Enter host IP: " HIP
BLOCKED_PORTS=`nmap -Pn -oG -p 32768-32775,137-139,111,515 $IP`
SYNFIN=`hping3 -S -F -c 1 $IP`
TEL=`hping3 -S -p 23 -c 1 $IP`
HOST=`hping3 -S -p 80 -c 1 $HIP`

