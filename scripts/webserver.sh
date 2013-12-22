#!/bin/bash
if [ -d "/opt/pwnpad/web-interface" ]; then
	echo "Starting webserver on localhost:8000"
	cd /opt/pwnpad/web-interface
	php -S localhost:8000
else
	apt-get -y install php5 php5-cli php-pear autossh
	cd /opt/pwnpad
	git clone https://github.com/binkybear/web-interface.git
	echo "Starting webserver on localhost:8000"
	php -S localhost:8000
fi