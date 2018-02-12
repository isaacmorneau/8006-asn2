#Outgoing fragments
hping3 -f -c 10 8.8.8.8

#DNS packets
hping3 -p 53 -c 10 8.8.8.8

#SYN/FIN packets
hping3 -SF -c 10 8.8.8.8

#Telnet packets
hping3 -p 23 -c 10 8.8.8.8

#TCP ports 32768-32775
hping3 -p 32767 -c 10 8.8.8.8
hping3 -p 32768 -c 10 8.8.8.8
hping3 -p 32770 -c 10 8.8.8.8
hping3 -p 32775 -c 10 8.8.8.8
hping3 -p 32776 -c 10 8.8.8.8

#TCP ports 137-139
hping3 -p 137 -c 10 8.8.8.8
hping3 -p 138 -c 10 8.8.8.8
hping3 -p 139 -c 10 8.8.8.8

#TCP ports 111, and 515
hping3 -p 111 -c 10 8.8.8.8
hping3 -p 515 -c 10 8.8.8.8

#Send SYN/ACK without SYN
hping3 -SA -c 10 8.8.8.8
