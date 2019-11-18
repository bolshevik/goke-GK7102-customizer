#!/bin/sh

# For INQMEGA
if [ -f /home/eye.conf ]; then
    mv ./eye.conf ./eye.conf.$current_time.old 2> /dev/null
    cp /home/eye.conf ./eye.conf
fi

# General flash dumper
for PART in 0 1 2 3 4 5 6 7; do
    echo "Dumping /dev/mtd$PART partition"
    [ -f ./mtd$PART.img ] && rm ./mtd$PART.img
    [ -c /dev/mtd$PART ] && dd if=/dev/mtd$PART of=./mtd$PART.img
done

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Gluing all dumped partitions"
mv ./fullDump.img ./fullDump.img.$current_time.old 2> /dev/null
for PART in 0 1 2 3 4 5 6 7; do
    [ -f ./mtd$PART.img ] && cat ./mtd$PART.img >> ./fullDump.img
done
