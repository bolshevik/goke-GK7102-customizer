#!/bin/sh

# TODO!
exit

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
# Change me
#INSTALL_PATH="/data/"
INSTALL_PATH="$BASEDIR/playground/data/"

DEST_FILENAME="pre_init.sh"
ENTRY="entry.sh"
MARKER="AUTOGENERATED ENTRY POINT, DO NOT EDIT THIS LINE"

if [ "$1" == "uninstall" ]; then 
    sed -i -e "/$MARKER/d" $INSTALL_PATH/$DEST_FILENAME
    exit $?
fi

if ! grep -q "$MARKER" $INSTALL_PATH/$DEST_FILENAME 2> /dev/null; then
    echo "[ -x $BASEDIR/$ENTRY ] && $BASEDIR/$ENTRY # $MARKER" >> $INSTALL_PATH/$DEST_FILENAME
fi

chmod +x $INSTALL_PATH/$DEST_FILENAME

mv $0 $0.disabled