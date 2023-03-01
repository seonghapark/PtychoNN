#!/bin/bash
set -x 
INC=1
MUL=3
for vsn in $*; do
    host="aps-$vsn"
    ssh "$host" bash -s < consumer-payload.sh $INC $MUL && echo "deployed! $vsn"
    INC=$((INC+MUL))
done