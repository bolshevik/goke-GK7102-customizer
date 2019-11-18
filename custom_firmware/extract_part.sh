#!/bin/sh

# Extract partitions from the firmware image to be used in chroot.
FILE=$1
if [ "$1" == "" ]; then
    FILE=Hip_Mod_fw_S.img

    echo "Usage: $0 FILENAME"
    echo "Defaulting FILENAME to $FILE"
fi

dd bs=65536 skip=31 count=29 if=$FILE of=mtd3_ro.img
dd bs=65536 skip=60 count=5  if=$FILE of=mtd4_config.img
dd bs=65536 skip=65 count=63 if=$FILE of=mtd5_home.img
