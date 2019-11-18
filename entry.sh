#!/bin/sh

# Scripts root directory. Change me if needed.
MOD=mod

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
MAIN_PATH="$BASEDIR/$MOD/main.sh"

[ -x $MAIN_PATH ] && $MAIN_PATH $@
