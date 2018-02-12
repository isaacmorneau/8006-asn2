#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi
IPA='iptables -A'
TCP='-m tcp -p tcp'
TCPM='-t mangle -p tcp'
UDP='-m udp -p udp'
ICMP='-m icmp -p icmp'
KRONOS='XxKr0n05xXx420blazeit'
GLOBAL='eno1'
INTERNAL='enp3s2'
SRC_IP=`./get_ip.sh $GLOBAL`
DEST_IP='192.168.1.5'

echo "Clearing existing tables"
iptables -F
iptables -X

echo "Creating user tables"
#Kronos handles all forwarding
iptables -N $KRONOS

echo "Setting default policy to DROP"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

echo "Setting accounting rules"
$IPA FORWARD -i $INTERNAL -o $GLOBAL -p all -j $KRONOS
$IPA FORWARD -i $GLOBAL -o $INTERNAL -p all -j $KRONOS

echo "Setting NAT forwarding rules"
iptables -t nat -A POSTROUTING -o $GLOBAL -m state --state NEW,ESTABLISHED -j SNAT --to-source $SRC_IP
iptables -t nat -A PREROUTING -i $GLOBAL -m state --state NEW,ESTABLISHED -j DNAT --to-destination $DEST_IP

echo "Drop all telnet"
$IPA $KRONOS $TCP --sport 23 -j DROP
$IPA $KRONOS $TCP --dport 23 -j DROP

echo "Block outgoing tcp traffic to listed ports"
$IPA $KRONOS $TCP --dport 32768:32775 -j DROP
$IPA $KRONOS $TCP --dport 137:139 -j DROP
$IPA $KRONOS $TCP --dport 111 -j DROP
$IPA $KRONOS $TCP --dport 515 -j DROP

echo "Drop SYN-FIN packets"
$IPA $KRONOS $TCP --tcp-flags SYN,FIN SYN,FIN -j DROP

echo "Drop incoming packets coming from outside with source of the inside"
$IPA $KRONOS -s 192.168.1.0/24 -j DROP

echo "Allowing fragments"
$IPA $KRONOS -f -j ACCEPT

echo "Set TOS for ftp and ssh"
$IPA -A PREROUTING $TCPM --sport 22 -j TOS --set-tos Minimize-Delay
$IPA -A PREROUTING $TCPM --sport 21 -j TOS --set-tos Minimize-Delay
$IPA -A PREROUTING $TCPM --sport 20 -j TOS --set-tos Maximize-Throughput
$IPA -A PREROUTING $TCPM --dport 22 -j TOS --set-tos Minimize-Delay
$IPA -A PREROUTING $TCPM --dport 21 -j TOS --set-tos Minimize-Delay
$IPA -A PREROUTING $TCPM --dport 20 -j TOS --set-tos Maximize-Throughput

echo "Loading the configs"
declare -a ACC_TCP_ARR
declare -a ACC_UDP_ARR
declare -a ACC_ICMP_ARR
readarray -t ACC_TCP_ARR < tcp_acpt.txt
readarray -t ACC_UDP_ARR < udp_acpt.txt
readarray -t ACC_ICMP_ARR < icmp_acpt.txt
#add accept rules for TCP, UDP, and ICMP to the chains
for p in ${ACC_TCP_ARR[@]}; do
    echo "Setting ACCEPT for TCP port $p"
    $IPA $KRONOS     $TCP --sport $p -m state --state NEW,ESTABLISHED -j ACCEPT
    $IPA $KRONOS     $TCP --dport $p -m state --state NEW,ESTABLISHED -j ACCEPT
done

for p in ${ACC_UDP_ARR[@]}; do
    echo "Setting ACCEPT for UDP port $p"
    $IPA $KRONOS     $UDP --sport $p -m state --state NEW,ESTABLISHED -j ACCEPT
    $IPA $KRONOS     $UDP --dport $p -m state --state NEW,ESTABLISHED -j ACCEPT
done

for p in ${ACC_ICMP_ARR[@]}; do
    echo "Setting ACCEPT for ICMP type $p"
    $IPA $KRONOS     $ICMP --icmp-type $p -m state --state NEW,ESTABLISHED -j ACCEPT
done
