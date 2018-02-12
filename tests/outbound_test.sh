#Outgoing fragments
echo "Fragment test"
if [ "`hping3 -f -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#DNS packets
echo "DNS test"
if [ "`hping3 -p 53 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#SYN/FIN packets
echo "SYN/FIN test"
if [ "`hping3 -SF -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#Telnet packets
echo "Telnet test"
if [ "`hping3 -p 23 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#TCP ports 32768-32775
echo "Port 32767 test"
if [ "`hping3 -p 32767 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
echo "Port 32768 test"
if [ "`hping3 -p 32768 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
echo "Port 32770 test"
if [ "`hping3 32770 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
echo "Port 32775 test"
if [ "`hping3 32775 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
echo "Port 32776 test"
if [ "`hping3 32776 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#TCP ports 137-139
echo "Port 137 test"
if [ "`hping3 -p 137 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
echo "Port 138 test"
if [ "`hping3 -p 138 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
echo "Port 139 test"
if [ "`hping3 -p 139 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#TCP ports 111, and 515
echo "Port 111 test"
if [ "`hping3 -p 111 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

echo "Port 515 test"
if [ "`hping3 -p 515 -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi

#Send SYN/ACK without SYN
echo "Orphan SYN/ACK test"
if [ "`hping3 -SA -c 10 8.8.8.8 2>&1 > /dev/null | grep -o -i 100%`" == "100%" ]; then
    echo "Test passed"
else
    echo "Test FAILED"
fi
