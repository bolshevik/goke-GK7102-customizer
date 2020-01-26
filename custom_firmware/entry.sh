#!/bin/sh

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"

source $BASEDIR/config.txt

# Set path to the full busybox path
export PATH=$BUSYBOX_PATH:$PATH

# Prepare configurations if no exist. Using $BASEDIR to make sure writing to /data is prevented e.g. in bad configuration.
if [ ! -f $BASEDIR/data/.wifi_conn_info ]; then
    echo "$MACADDR" > $BASEDIR/data/myuid.bin
    echo "$MACADDR" | sed 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI' | xargs printf > $BASEDIR/data/mac.ini
    # Create wifi configuration and mark last entry as empty.
    $BASEDIR/edit_config.arm -config "$BASEDIR/data/.wifi_conn_info" -current 0 -index 0 -ssid "$WIFI_SSID" -password "$WIFI_PASS" -reset 1
fi

# Disables watchdog to prevent reboot.
( while [ ! -f /tmp/watch_done ]; do sleep 1; echo "V" > /dev/watchdog; done; rm -rf /tmp/watch_done ) &

source $BASEDIR/kill_p2pcam.sh

source $BASEDIR/mount_k21.sh

export g_gk_flash_size=8m

# Disable wlan as ipc will connect to it again.
ifconfig wlan0 down
killall wpa_supplicant
killall udhcpc

# Prevent updates
mount --bind $BASEDIR/mods/version.ini $NEW_ROOT/home/version.ini
# Remove mtd devices from the chroot environment to prevent modifications via updates
# hopefully ipc should fail without these
rm $NEW_ROOT/dev/mtd*

( $BUSYBOX_PATH/chroot $NEW_ROOT /home/ipc sensortype=gc2053 > $LOG_PATH/wanscam.log 2>&1 ) &

# Stop the watchdog loop above
( sleep 30 && touch /tmp/watch_done ) &
