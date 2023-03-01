#!/bin/bash

echo "deploying a sim server"
docker run -d --rm \
  --name pva-sim-server \
  --network host \
  --entrypoint pvapy-ad-sim-server \
  classicblue/ptychonn:0.5.3 \
  --channel-name ad:image \
  --n-x-pixels 512 \
  --n-y-pixels 512 \
  --datatype int16 \
  --frame-rate 2000 \
  --runtime 60 \
  --disable-curses
