#!/bin/sh

if [ "$NEW_ROOT" == "" ]; then
    echo "Set NEW_ROOT variable"
    exit
fi

if [ "$BASEDIR" == "" ]; then
    BASEDIR=.
fi

mkdir -p $NEW_ROOT

# Mount Wanscam K21 firmware
mount -t squashfs -o loop $BASEDIR/mtd3_ro.img $NEW_ROOT
mount -t squashfs -o loop $BASEDIR/mtd5_home.img $NEW_ROOT/home/
mount --bind $BASEDIR/data $NEW_ROOT/data/
mount --bind /media/ $NEW_ROOT/media/

# Mount pseudo-filesystems and tmp
mount -t proc none $NEW_ROOT/proc
mount --rbind /sys $NEW_ROOT/sys/
mount --rbind /tmp $NEW_ROOT/tmp/

# Move etc to /tmp/
mkdir -p $NEW_ROOT/tmp/wanscam_etc/
cp -R $NEW_ROOT/etc/* $NEW_ROOT/tmp/wanscam_etc/
mount --bind $NEW_ROOT/tmp/wanscam_etc/ $NEW_ROOT/etc/

# See /etc/init.d/rcS in the root image
# Executed to match possible firmware requirements
mount --bind $NEW_ROOT/tmp/ $NEW_ROOT/var/
mkdir -p $NEW_ROOT/var/run/hostapd
mkdir -p $NEW_ROOT/var/lib/misc
touch $NEW_ROOT/var/lib/misc/udhcpd.leases
mkdir -p $NEW_ROOT/var/run/wpa_supplicant

# Copy sensor firmwares into chroot
cp -r /etc/sensors/* $NEW_ROOT/etc/sensors/

# Cleanup old kernel modules and load those used by ipc.
rmmod timer_drv
rmmod gkptz_gpio
rmmod gio

insmod $NEW_ROOT/home/ko/hi_reg.ko
insmod $NEW_ROOT/home/ko/goke_gpio.ko
insmod $NEW_ROOT/home/ko/gpioi2c.ko
insmod $NEW_ROOT/home/ko/timer_drv.ko

# Prepare devs.
mount -t tmpfs defaults $NEW_ROOT/dev/
$BUSYBOX_PATH/chroot $NEW_ROOT /bin/sh /etc/init.d/S10mdev start
$BUSYBOX_PATH/chroot $NEW_ROOT /bin/sh /etc/init.d/S11devnode start
$BUSYBOX_PATH/chroot $NEW_ROOT /bin/sh /etc/init.d/S20urandom start
