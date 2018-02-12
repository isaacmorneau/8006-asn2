#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi

INT='enp3s2'
IP='192.168.1.5'
DEST='192.168.1.6'
MASK='255.255.255.0'

echo "Enabling interface $INT"
ifconfig $INT up
echo "Setting IP $IP/$MASK"
ifconfig $INT $IP netmask $MASK
echo "Setting default gateway to $DEST"
ip route add default via $DEST dev $INT
