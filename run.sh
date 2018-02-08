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

echo "Clearing existing tables"
#drop tcp existing rules and user chains
iptables -F
iptables -X

echo "Creating user tables"

echo "Setting default policy to DROP"
#set drop as default
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#initialize acounting rules
IO_ARR=('INPUT' 'OUTPUT')
for t in ${IO_ARR[@]}; do
    echo "Setting accounting rules for $t"
    $IPA $t $TCP --sport www -j ENTRY
    $IPA $t $TCP --dport www -j ENTRY
    $IPA $t $TCP --sport ssh -j ENTRY
    $IPA $t $TCP --dport ssh -j ENTRY
done

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
    $IPA ENTRY     $TCP --sport $p -j ACCEPT
    $IPA ENTRY     $TCP --dport $p -j ACCEPT
done

for p in ${ACC_UDP_ARR[@]}; do
    echo "Setting ACCEPT for UDP port $p"
    $IPA ENTRY     $UDP --sport $p -j ACCEPT
    $IPA ENTRY     $UDP --dport $p -j ACCEPT
done

for p in ${ACC_ICMP_ARR[@]}; do
    echo "Setting ACCEPT for ICMP type $p"
    $IPA ENTRY     $ICMP --icmp-type $p -j ACCEPT
done
