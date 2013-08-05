su
echo "Sleep for 30 seconds"
sleep 20
mount -o remount,rw -t yaffs2 /dev/block/mtdblock3 /system
export bin=/system/bin
export mnt=/data/local/kali
PRESERVED_PATH=$PATH
export PATH=/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin:$PATH
export TERM=linux
export HOME=/root
export LOGNAME=root

# mount to Kali chroot
echo "mounting..."

mount -o bind /system $mnt/system
mount -o bind /sdcard $mnt/sdcard
mount -o bind /dev $mnt/dev
mount -t devpts devpts $mnt/dev/pts
mount -t proc proc $mnt/proc
mount -t sysfs sysfs $mnt/sys

# set 250mb max memory for postgresql

sysctl -w kernel.shmmax=268435456

# set networking

sysctl -w net.ipv4.ip_forward=1
echo "nameserver 8.8.8.8" > $mnt/etc/resolv.conf
echo "nameserver 8.8.4.4" >> $mnt/etc/resolv.conf
echo "127.0.0.1 localhost" > $mnt/etc/hosts

# execute startup script
echo "Starting SSH server..."
chroot $mnt /etc/init.d/ssh start
# echo "Starting VNC server..."
# /usr/bin/vncserver :0 -geometry 1200x800

echo "Background chroot service complete"
