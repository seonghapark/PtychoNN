#!/bin/bash

INC=1
for vsn in $*; do
    host="aps-$vsn"
    ssh "$host" -x 'docker rm -f $(docker ps --filter name=pva-consumer-* -q) && echo "cleaned! $vsn"'
    INC=$((INC+1))
done