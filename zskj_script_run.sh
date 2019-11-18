#!/bin/sh

# Uncomment to debug via unsecured connection.
#telnetd &

BASEDIR="$( cd "$(dirname "$0")" ; pwd -P )"
[ -x $BASEDIR/entry.sh ] && $BASEDIR/entry.sh
