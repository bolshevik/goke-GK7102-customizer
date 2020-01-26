#!/bin/sh

$BUSYBOX_PATH/chroot $NEW_ROOT /home/sensor_detect
SENSOR_ID=$?

# See run_init.sh in the custom firmware.
case $SENSOR_ID in
    26)
        SENSORTYPE=gc2033
        ;;
    33)
        SENSORTYPE=gc2053
        ;;
    37)
        SENSORTYPE=gc1034
        ;;
	*)
		echo "Unknown sensor with ID: $SENSOR_ID"
		;;
esac
