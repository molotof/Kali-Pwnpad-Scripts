#!/bin/bash

## date format ##
NOW=$(date +"%m-%d-%y-%H%M")

mkdir -p "/opt/pwnpad/captures/kismet_db"
giskismet -x /opt/pwnpad/captures/kismet/*.netxml --database "/opt/pwnpad/captures/kismet_db/wireless.dbl"

# export kml of all wireless data
giskismet -q "select * from wireless" -o "/opt/pwnpad/captures/kismet/kismet-$NOW.kml"
echo "Created kismet-$NOW.kml file for Google Earth"
cd /sdcard/
zip -rj "kismet-captures-$NOW.zip" /opt/pwnpad/captures/kismet/
echo "Successfully copied to /sdcard/kismet-captures-$NOW.zip"

# option to erase files

read -p "Would you like to erase files in Kismet folder? (y/n)" CONT
if [ "$CONT" == "y" ]; then
	echo "Removing capture files..."
	wipe -f -i -r /opt/pwnpad/captures/kismet/*
else
  echo "Success!";
fi
exit
