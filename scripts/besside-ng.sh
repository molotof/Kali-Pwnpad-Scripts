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
f_clean_handshake(){
NOW=$(date +"%m-%d-%y-%H%M%S")
besside-ng-crawler "/opt/pwnpad/captures/besside-ng/ out.cap"
cd /sdcard/
zip -rj "besside-ng$NOW.zip" /opt/pwnpad/captures/besside-ng/
echo "/sdcard/besside-ng$NOW.zip saved"
sleep 5
}
#####################################################
# ERASE OLD FILES
#####################################################
f_erase(){
read -p "Would you like to erase all files in besside-ng folder? (y/n)" CONT
if [ "$CONT" == "y" ]; then
	echo "Removing capture files..."
	wipe -f -i -r /opt/pwnpad/captures/besside-ng/*
else
  echo "All files copied successfully!";
fi
exit
}
#####################################################
clear
f_wireless
f_besside_ng
f_clean_handshake
f_erase