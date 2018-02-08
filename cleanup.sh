#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi

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
