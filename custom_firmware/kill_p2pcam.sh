#!/bin/sh

PID=$(ps | grep "/bin/sh /home/start.sh" | grep -v grep | awk '{print($1);}')
kill -9 $PID

PID=$(ps | grep "p2pcam" | grep -v grep | awk '{print($1);}')
kill -9 $PID

PID=$(ps | grep "tees" | grep -v grep | awk '{print($1);}')
kill -9 $PID

PID=$(ps | grep "/home/rsyscall.goke" | grep -v grep | awk '{print($1);}')
kill -9 $PID

# Small cleanup to have more RAM.
rm -rf /tmp/VOICE/
rm -rf /tmp/closelicamera.log

umount /p2pcam
