#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi

GLOBAL='eno1'
INT='enp3s2'
IP='192.168.1.5'
MASK='255.255.255.0'
GATE='192.168.1.1'

NAMESERVER='''
nameserver 8.8.8.8
nameserver 8.8.4.4
'''

echo "Disabling interface $GLOBAL"
ifconfig $GLOBAL down
echo "Enabling interface $INT"
ifconfig $INT $IP up
echo "Setting Gateway $GATE"
route add default gw $GATE

cp /etc/resolv.conf  resolv.conf.bak
echo "$NAMESERVER" > /etc/resolv.conf

