#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 INTERVAL SAVE_PATH"
  exit 1
fi

INTERVAL="$1"
SAVE_PATH="$2"

if [ "$INTERVAL" == "" ]; then
    INTERVAL=600
fi

while true
do
    sleep "$INTERVAL"
    NOW=`date +%Y`
    if [ "$NOW" -ge "2018" ]; then
        date "+%Y.%m.%d-%H:%M:%S" > $SAVE_PATH
    fi
done
