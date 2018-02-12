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

#Drop tcp existing rules
iptables -F

#Drop tcp existing non-default chains
iptables -X

#Reset default policies
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

#Zero out any counters
iptables -Z

#Reset resolver config
cp resolv.conf.bak /etc/resolv.conf

#Reset network cards
ifconfig $GLOBAL up
ifconfig $INT down
route del default gw $GATE
