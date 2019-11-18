#!/bin/sh

# Load config.txt in the current directory
load_config () {
    [ -f config.txt ] && source config.txt
}

# $1 $2 ... MESSAGE: Message to log
log_msg () {
    if [ "$LOG_ENABLED" -eq "1" ]; then
        log_path=$LOG_PATH/main.log

        if [ "" != "$MODULE_LOG_FILENAME" ] ; then
            log_path="$MODULE_LOG_FILENAME"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@" | tee -a $log_path
    fi
}

# pushd emulation for busybox based on http://lists.netisland.net/archives/plug/plug-2009-10/msg00003.html
pushd () {
    DIRS="$PWD
$DIRS"
    cd $@
}

# popd emulation for busybox based on http://lists.netisland.net/archives/plug/plug-2009-10/msg00003.html
popd () {
    LINE=`echo "\$DIRS" | sed -ne '1p'`
    [ "$LINE" != "" ] && cd $LINE
    DIRS=`echo "\$DIRS" | sed -e '1d'`
}

# $1, $2, ... MODULES: list of modules
check_boot_dependencies () {
    for dep_module in "$@"; do
        flag=$(eval "echo \$MODULE_BOOTED_$dep_module")
        if [ "$flag" != '1' ]; then
            return 1
        fi
    done

    return 0
}

# $1, $2, ... MODULES: list of modules
check_run_dependencies () {
    for dep_module in "$@"; do
        flag=$(eval "echo \$MODULE_RAN_$dep_module")
        if [ "$flag" != '1' ]; then
            return 1
        fi
    done

    return 0
}

# $1 TYPE: shown in the message
# $2 FILENAME: name of the file to include
loop_modules () {
    TYPE="$1"
    FILENAME="$2"

    for MODULE in $MODULES ; do
        MODULE_DIR=$BASEDIR/modules/$MODULE
        if [ -d $MODULE_DIR ] && [ -f $MODULE_DIR/$FILENAME ]; then
            # Allow to disable logs for a particular module.
            module_log=$(eval "echo \$LOG_DISABLE_$MODULE")

            pushd $MODULE_DIR > /dev/null
            if [ "$module_log" == "1" ]; then
                MODULE_LOG_FILENAME=/dev/null
            else
                log_msg "$TYPE $MODULE"
                MODULE_LOG_FILENAME=$LOG_PATH/$MODULE.log
            fi

            source ./$FILENAME
            MODULE_LOG_FILENAME=
            popd > /dev/null
        fi

        eval MODULE_BOOTED_$MODULE=1
        MODULE=
    done
}
