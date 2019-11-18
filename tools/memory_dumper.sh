#!/bin/sh

# Dumps process memory.

cat /proc/$1/maps | grep -Fv ".so" | grep " 3 " | awk '{print $1}' | ( IFS="-"
while read a b; do
    echo $a $b
    ad=$(printf "%llu" "0x$a")
    bd=$(printf "%llu" "0x$b")
    ad=`expr $ad \/ 4096`
    bd=`expr $bd \/ 4096`

    dd if=/proc/$1/mem bs=4096 skip=$ad count=$(( bd-ad )) of=$1_mem_$a.bin
done )
