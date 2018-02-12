#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi

INT='enp3s2'
IP='192.168.1.1'
IP_BASE='192.168.1.0'
MASK='255.255.255.0'
NAMESERVER='''
nameserver 8.8.8.8
nameserver 8.8.4.4
'''

echo "Enabling interface $INT"
ifconfig $INT up
echo "Setting IP $IP/$MASK"
ifconfig $INT $IP netmask $MASK
echo "1" >/proc/sys/net/ipv4/ip_forward
route add -net 192.168.0.0 netmask $MASK gw 192.168.0.100
route add -net $IP_BASE/24 gw $IP

cp /etc/resolv.conf resolv.conf.bak
echo "$NAMESERVER" > /etc/resolv.conf

