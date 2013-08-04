#!/bin/bash

## date format ##
NOW=$(date +"%m-%d-%y-%H%M")

echo "Adding Kismet data to local database"
# add kismet data to giskmet database
giskismet -x /opt/pwnpad/captures/kismet/Kismet*.netxml

# export kml of all wireless data
giskismet -q "select * from wireless" -o "/opt/pwnpad/captures/kismet/kismet-$NOW.kml"
echo "Created Kismet KML file for Google Earth"

cd /sdcard/
zip -rj "kismet-captures-$NOW.zip" /opt/pwnpad/captures/kismet/
echo "Successfully copied to /sdcard/kismet-captures-$NOW.zip"

echo "Removing capture files..."

wipe -f -i -r /opt/pwnpad/captures/kismet/*
