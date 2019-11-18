#!/bin/sh

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
LOG_PATH=$BASEDIR/logs/
TMP_PATH=$BASEDIR/tmp/

source $BASEDIR/functions.sh

pushd $BASEDIR > /dev/null

mkdir -p $LOG_PATH 2> /dev/null
mkdir -p $TMP_PATH 2> /dev/null
load_config

if [ "$#" -ge 1 ]; then
    MODULES="$@"
fi

loop_modules "Booting" "boot"
loop_modules "Running" "run"

popd > /dev/null