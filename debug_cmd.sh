#!/bin/sh

SD_MOUNT=/media

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"

# Mount sd card to separate location, it is needed because
# the original parent script unmounts SD card
if [ -b /dev/mmcblk0p1 ]; then
    mount -t vfat /dev/mmcblk0p1 $SD_MOUNT
elif [ -b /dev/mmcblk0 ]; then
    mount -t vfat /dev/mmcblk0 $SD_MOUNT
fi

[ -x $SD_MOUNT/entry.sh ] && $SD_MOUNT/entry.sh

# Kill tenetd
(while true; do sleep 10; killall telnetd; if [ $? -eq 0 ]; then break; fi; done;) &

# Enable or disable below running of the K21 firmware.
# Read custom_firmware/readme.md before activating it.
#( sleep 30 && $SD_MOUNT/custom_firmware/entry.sh ) &
