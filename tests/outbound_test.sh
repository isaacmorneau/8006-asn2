#Outgoing fragments
echo "Fragment test"
if [ "`hping3 -S -f -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#DNS packets
echo "DNS test"
if [ "`hping3 -S -p 53 -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#SYN/FIN packets
echo "SYN/FIN test"
if [ "`hping3 -SF -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#Telnet packets
echo "Telnet test"
if [ "`hping3 -S -p 23 -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#TCP ports 32768-32775
echo "Ports 32768-32775 test"
if [ "`nmap -p 32768-32775 8.8.8.8 | grep filtered | wc -l`" == "8" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#TCP ports 137-139
echo "Port 137-139 test"
if [ "`nmap -p 137-139 8.8.8.8 | grep [sr]ed | wc -l`" == "3" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#TCP ports 111, and 515
echo "Port 111 test"
if [ "`hping3 -S -p 111 -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Port 515 test"
if [ "`hping3 -S -p 515 -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#Send SYN/ACK without SYN
echo "Orphan SYN/ACK test"
if [ "`hping3 -SA -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
#TCP Christmas
echo "Chirstmas test"
if [ "`hping3 -FSRPAUXY -c 3 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
