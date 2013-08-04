#!/bin/bash
echo "#####################
#####################
# WPA Setup Script
# Author: SecureMaryland
# Helps connect wlan1 to WPA/WPA2 AP
#####################
#####################

"
#####
# function
wlan1check(){
adaptor=`ip addr |grep wlan1`
if [ -z "$adaptor" ]; then
echo "This script requies wlan1 to be plugged in."
echo "I cant see it so exiting now. Try again when wlan1 is plugged in."
exit 1
fi
}
#####
# function
killOld(){
if [ -f /opt/pwnpad/captures/wpapid ]
then
wpapid=`cat /opt/pwnpad/captures/wpapid`
echo "The pid of the old proces is: " $wpapid
echo "Killing any old stuff (pid:"$wpapid") before we start."
kill $wpapid
sleep 1
fi
ifconfig wlan1 down
}
#####
#####
# function
upInterface(){
echo "Putting wlan1 in managed mode via iwconfig wlan1 mode managed command"
iwconfig wlan1 mode managed
echo "Bringing up the interface"
ifconfig wlan1 up
sleep 2
}
#####
#####
#function
setssid(){
echo "Scanning for networks - this may take a second. 
I see the following available networks:"
iwlist wlan1 scan|grep SSID |awk -F'"' '{print $2}'
sleep 5
echo "Please type the SSID you want to connect to. Check your spelling:"
read ssid
}
wlan1check
killOld
upInterface
while true; do
setssid
read -p "Is "$ssid" correct [y|Y/n|N]" choice
case $choice in
[yY]* ) break;;
*) esac
done
echo "Please enter the password for" $ssid" check your spelling. This script has no error checking:"
wpa_passphrase $ssid >wpa.conf
echo "Trying to connect..."
wpa_supplicant -B -P /opt/pwnpad/captures/wpapid -D wext -i wlan1 -c ./wpa.conf 
sleep 5
echo "Obtaining IP address"
dhclient wlan1
rm wpa.conf
ifconfig wlan1
echo "Done"
