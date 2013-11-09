
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
toilet -f standard -F metal "KaliPWN Config"
echo "************************"
echo "[1] Generate new SSH Keys"
echo "[2] Update Scripts"
echo "[3] Update Everything (MSF/OpenVAS/Kali)"
echo "[4] Create Metasploit Postgresql Database/User"
echo "[5] Change VNC password"
echo "[6] OpenVAS Maintenance"
echo "[7] Configure Timezone"
echo "#### VNC Maintenance #####"
echo "[8] Kill all VNC instances (remove pid/logs)"
echo "[9] Start VNC server"
echo "##########################"
echo "[0] Exit"
echo -n "Enter your menu choice [1-7]: "

# wait for character input

read -p "Choice:" menuchoice

case $menuchoice in

1) f_sshkeys ;;
2) f_updatescripts ;;
3) f_updateall ;;
4) f_metasploit ;;
5) f_vncpasswd ;;
6) f_openvas ;;
7) f_timezone ;;
8) f_vnckill ;;
9) f_vncstart ;;
0) exit 0 ;;
*) echo "Incorrect choice..." ;
esac
}

##################################################################
#                   GENERATE NEW SSH KEYS                        #
##################################################################
f_sshkeys() {
#	clear
#	read -p echo "Do you wish to backup your old SSH keys to your sdcard also? (y/n)" CONT
#
#if [ "$CONT" == "y" ]; then
#
#	NOW=$(date +"%m-%d-%y-%H%M%S")
#	echo "Copying old certificates to /sdcard/certs_backup.zip"
#	sleep2
#	zip -rj certs_backup.zip ~/.ssh/*
# else
	echo "Generating new keys and removing old ones."
	echo "Password is optional and NOT recommended for automatic login."
	sleep 3
	cd ~/.ssh/
	rm *
	sleep 3
	ssh-keygen -t rsa
	echo "Creating authorized_keys file for passwordless login in ~/.ssh/"
	sleep 1
	cat id_rsa.pub > authorized_keys
	echo "Finished!"
	sleep 2
	f_interface
}

##################################################################
#                   Update KaliPWN Scripts                       #
##################################################################
NOW=$(date +"%m-%d-%y-%H%M%S")

f_updatescripts() {
	clear
	echo "This will pull scripts from Github. This will not check for updates."  
	echo "If you have made any changes to the scripts you should not run this."
	read -p "Do you wish to continue? (y/n)" CONT

if [ "$CONT" == "y" ]; then

	echo "Creating backup of old scripts in /opt/pwnpad/scripts/backup_scripts$NOW.zip"
	sleep 3
	cd /opt/pwnpad/scripts/
	zip -p "backup_scripts$NOW.zip" *.sh
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
#                   Update KaliPWN Scripts                       #
##################################################################
f_updateall(){
	clear
	echo "Updating Kali..."
	sleep 2
	apt-get update && apt-get -y upgrade && apt-get clean
	echo "Updating Metasploit (this could take a while)...."	
	sleep 2
	msfupdate
	echo "Updating OpenVAS"
	sleep 2
	openvas-nvt-sync
	f_interface
}
##################################################################
#                   VNC Password Change                          #
##################################################################
f_vncpasswd(){
	clear
	echo "Change your VNC password:"
	vncpasswd
	f_interface
}
##################################################################
#                   Generate metasploit user/db                  #
##################################################################
f_metasploit() {
	service postgresql
	echo "Switching to user postgres"
	su postgres	
	read -p "Enter Metasploit database username:" msuser
	createuser -D -P -R -S $msuser
	read -p "Enter Metasploit database name:" dbname
	createdb --owner=$msuser $dbname
	su root
	echo "You can now add database connection to startup at ~/.msf4/msfconsole.rc"
	echo "Just add:"
	echo "db_connect $msuser:YOURPASSWORD@127.0.0.1:5432/$dbname"
	sleep 4
	f_interface
	}
##################################################################
#                   OpenVAS Main.                                #
##################################################################
f_openvas(){
clear
echo "[1] Add User"
echo "[2] Remove User"
echo "[3] Make Certificates"
echo "[4] Exit to main menu"
echo -n "Enter your menu choice [1-4]: "
read -p "Choice:" vasmenuchoice

case $vasmenuchoice in
1) openvas-adduser ;;
2) openvas-rmuser ;;
3) openvas-mkcert ;;
4) f_interface ;;
*) echo "Incorrect choice..." ;
esac
}
##################################################################
#                   CHANGE TIMEZONE                              #
##################################################################
f_timezone(){
	dpkg-reconfigure tzdata;
	f_interface
}

##################################################################
#                   KILL ALL VNC                                 #
##################################################################
f_vnckill(){
	echo "Removing all PID and log files from /root/.vnc/"
	echo "Killing all VNC process ID's"
	sleep 2
	kill $(ps aux | grep 'Xtightvnc' | awk '{print $2}')
	echo "Removing PID files"
	sleep 2
	rm /root/.vnc/*.pid;
	echo "Removing log files"
	sleep 2
	rm /root/.vnc/*.log;
	echo "Removing lock file"
	sleep 2
	rm -vrf "/tmp/\.*"
	echo "All VNC process/logs have been removed"
	sleep 3
	f_interface
}
##################################################################
#                   VNC START                                    #
##################################################################
f_vncstart(){
	echo "Starting VNC Server"
	sleep 2
	vncserver -geometry 1280x1024 -depth 24
	echo "Your display number will be the last number of the port"
	echo "So display :1 will be port 5901"
	sleep 5
	f_interface
}
##################################################################
f_interface