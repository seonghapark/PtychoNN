#!/bin/bash

INC=1
for vsn in $*; do
    host="aps-$vsn"
    ssh "$host" bash -s < consumer-payload.sh $INC && echo "deployed! $vsn"
    INC=$((INC+1))
done