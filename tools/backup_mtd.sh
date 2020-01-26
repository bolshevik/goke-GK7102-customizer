#!/bin/sh

# For INQMEGA
if [ -f /home/eye.conf ]; then
    mv ./eye.conf ./eye.conf.$current_time.old 2> /dev/null
    cp /home/eye.conf ./eye.conf
fi

# General flash dumper
for PART in $(cat /proc/mtd | grep mtd | cut -d ':' -f 1); do
    echo "Dumping /dev/$PART partition"
    [ -f ./$PART.img ] && rm ./$PART.img
    [ -c /dev/$PART ] && dd if=/dev/$PART of=./$PART.img
done

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Glueing all dumped partitions"
mv ./fullDump.img ./fullDump.img.$current_time.old 2> /dev/null
for PART in $(cat /proc/mtd | grep mtd | cut -d ':' -f 1); do
    [ -f ./$PART.img ] && cat ./$PART.img >> ./fullDump.img
done
