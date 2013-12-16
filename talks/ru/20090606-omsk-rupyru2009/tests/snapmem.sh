#!/bin/sh

#
# Runs the specified program in background, waits <first arg> seconds and then
# captures the memory snapshot (smaps) of the program
#
TIMEOUT="$1"
shift

"$@"&
ID=$!
sleep $TIMEOUT
if ! cat /proc/$ID/smaps >&2; then
    kill -9 $ID
    return 1
else
    kill $ID
    wait
fi
