
#!/bin/bash
#
# Set up script for new logins / passwords
#
##################################################################
#                   		MENU                                 #
##################################################################
f_interface(){
clear
echo "************************"
echo "* KaliPWN Set up Script *"
echo "************************"
echo "[1] Generate new SSH Keys"
echo "[2] Update Kali Scripts"
echo "[3] "
echo "[4] "
echo "[0] Exit"
echo -n "Enter your menu choice [1-3]: "

# wait for character input

read -p "Choice:" menuchoice

case $menuchoice in

1) f_sshkeys ;;
2) f_updatescripts ;;
3)  ;;
4)  ;;
0) exit 0 ;;
*) echo "Incorrect choice..." ;
esac
}

##################################################################
#                   GENERATE NEW SSH KEYS                        #
##################################################################
f_generatesssh(){
	echo "Generating new keys and removing old ones."
	echo "Password is optional and NOT recommended for automatic login."
	sleep 3
	cd ~/.ssh/
	rm *
	sleep 3
	ssh-keygen -t rsa
	echo "Creating authorized_keys file for passwordless login in ~/.ssh/"
	sleep 3
	cat id_rsa.pub > authorized_keys
	echo "Finished!"
	sleep 3
	f_interface
}

f_sshkeys() {

read -p echo "Do you wish to backup your old SSH keys to your sdcard also? (y/n)" CONT

if [ "$CONT" == "y" ]; then

	NOW=$(date +"%m-%d-%y-%H%M%S")
	echo "Copying old certificates to /sdcard/certs_backup.zip"
	sleep2
	cd /sdcard/
	zip -rj certs_backup.zip ~/.ssh/*
	f_generatessh()
else
	f_generatessh()
fi
}
##################################################################
#                   Update KaliPWN Scripts                       #
##################################################################
f_updatescripts() {

	echo "This will pull scripts from Github. This will not check for updates."  
	echo "If you have made any changes to the scripts you should not run this."
	read -p echo "Do you wish to continue? (y/n)" CONT

if [ "$CONT" == "y" ]; then

	NOW=$(date +"%m-%d-%y-%H%M%S")

	echo "Creating backup of old scripts in /opt/pwnpad/scripts/backup_scripts$NOW.zip"
	sleep 3
	cd /opt/pwnpad/scripts/
	zip -p backup_scripts$NOW.zip ()

	echo "Downloading scripts to temporary folder (/tmp)"
	sleep 2
	cd /tmp/
	git clone https://github.com/binkybear/Kali-Pwnpad-Scripts.git
	echo "Copying scripts to /opt/pwnpad/scripts"
	cp Kali-Pwnpad-Scripts/scripts/* /opt/pwnpad/scripts
	cd /opt/pwnpad/scripts/
	chmod +x *.sh
	echo "Removing temporary downloads"
	rm -rf /tmp/Kali-Pwnpad-Scripts
	f_interface
else
	f_interface
fi	
}
##################################################################
f_interface

