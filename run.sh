#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi
IPA='iptables -A'
TCP='-m tcp -p tcp'
UDP='-m udp -p udp'
ICMP='-m icmp -p icmp'
KRONOS='XxKr0n05xXx420blazeit'

echo "Clearing existing tables"
#drop tcp existing rules and user chains
iptables -F
iptables -X

echo "Creating user tables"
#Kronos handles all forwarding
iptables -N $KRONOS

echo "Setting default policy to DROP"
#set drop as default
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#initialize acounting rules
echo "Setting accounting rules"
$IPA FORWARD -p all -j $KRONOS

#load the configs into arrays
declare -a ACC_TCP_ARR
declare -a ACC_UDP_ARR
declare -a ACC_ICMP_ARR
readarray -t ACC_TCP_ARR < tcp_acpt.txt
readarray -t ACC_UDP_ARR < udp_acpt.txt
readarray -t ACC_ICMP_ARR < icmp_acpt.txt
#add accept rules for TCP, UDP, and ICMP to the chains
for p in ${ACC_TCP_ARR[@]}; do
    echo "Setting ACCEPT for TCP port $p"
    $IPA $KRONOS     $TCP --sport $p -j ACCEPT
    $IPA $KRONOS     $TCP --dport $p -j ACCEPT
done

for p in ${ACC_UDP_ARR[@]}; do
    echo "Setting ACCEPT for UDP port $p"
    $IPA $KRONOS     $UDP --sport $p -j ACCEPT
    $IPA $KRONOS     $UDP --dport $p -j ACCEPT
done

for p in ${ACC_ICMP_ARR[@]}; do
    echo "Setting ACCEPT for ICMP type $p"
    $IPA $KRONOS     $ICMP --icmp-type $p -j ACCEPT
done
