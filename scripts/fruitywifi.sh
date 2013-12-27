#!/bin/bash
if [ -d "/var/www/FruityWifi" ]; then
	echo "Starting webserver on localhost:8000"
	service atd start
	cd /var/www/FruityWifi/
	clear
	echo "Default login/password: admin"
	php -S localhost:8000
else
	echo "This will install necessary pre-requistes such as"
	echo "autossh, PHP, and AT needed for webserver"
	cd /opt/pwnpad
	git clone https://github.com/binkybear/FruityWifi.git
	cd FruityWifi
	chmod +x install-kalipwn.sh
	./install-kalipwn.sh;
	clear
	echo "Install finished. Default login/password: admin"
	echo "Starting webserver on localhost:8000"
	cd /var/www/FruityWifi/
	php -S localhost:8000
fi