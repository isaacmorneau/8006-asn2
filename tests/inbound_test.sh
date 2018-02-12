#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "Requesting Root" 1>&2
    sudo ${0}
    exit 0
fi
read -p "Enter firewall IP: " IP
read -p "Enter host IP: " HIP

BLOCKED_PORTS=`nmap -Pn -oG - -p 32768-32775,137-139,111,515 $IP`
SYNFIN=`hping3 -S -F -c 1 $IP 2>&1`
TEL=`hping3 -S -p 23 -c 1 $IP 2>&1`
HOST=`hping3 -S -p 80 -c 1 $HIP 2>&1`

echo "Blocked Ports 32768-32775,137-139,111,515 test"
if [ "`nmap -Pn -p 32768-32775,137-139,111,515 $IP | grep -o -i filtered | wc -l`" == "13" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Allowed TCP test"
if [ "`hping3 -p 22 -S -c 3 $IP 2>&1 > /dev/null | grep -o -i 0%`" == "0%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Blocked UDP test"
if [ "`hping3 -p 50000 -2 -c 3 $IP 2>&1 > /dev/null | grep -o -i ICMP | wc -l`" == "0" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Allowed UDP test"
if [ "`hping3 -p 22 -2 -c 3 $IP 2>&1 > /dev/null | grep -o -i ICMP | wc -l`" == "3" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Blocked SynFin test"
if [ "`hping3 -p 22 -SF -c 3 $IP 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Blocked Telnet test"
if [ "`hping3 -p 23 -S -c 3 $IP 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Blocked Internal Destination test"
if [ "`hping3 -p 22 -S -c 3 $HIP 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Blocked Internal Source test"
if [ "`hping3 -a 192.168.0.6 -S -p 22 -c 3 $IP 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
