#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi

INT='enp3s2'
IP='192.168.1.5'
MASK='255.255.255.0'

echo "Enabling interface $INT"
ifconfig $INT up
echo "Setting IP $IP/$MASK"
ifconfig $INT $IP netmask $MASK
