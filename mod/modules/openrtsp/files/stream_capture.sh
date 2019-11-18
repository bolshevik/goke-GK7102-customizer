#!/bin/sh

if [ "$#" -ne 5 ]; then 
  echo "Usage: $0 VIDEO_DIR USER PASS RTP_URL LOG_FILE [CUSTOM_PARAM]"
  exit 1
fi

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"

VIDEO_DIR=$1
USER=$2
PASS=$3
URL=$4
LOG_FILE=$5
CUSTOM_PARAM=$6

if [ "" == "$CUSTOM_PARAM" ] ; then
  CUSTOM_PARAM="-4 -t -l -P 600 -I 127.0.0.1 -p 60000 -K -w 1280 -h 720 -f 12"
fi

while true
do
  sleep 30
  cd $VIDEO_DIR
  mv $LOG_FILE $LOG_FILE.`date +%Y%m%d_%H_%M_%S`
  $BASEDIR/openRTSP -u "$USER" "$PASS" $CUSTOM_PARAM "$URL" >> $LOG_FILE 2>&1
done

