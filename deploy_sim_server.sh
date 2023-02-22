#!/bin/bash

echo "deploying a sim server"
docker run -d --rm \
  --name pva-sim-server \
  --network host \
  --entrypoint pvapy-ad-sim-server \
  classicblue/ptychonn:0.4.0 \
  --channel-name ad:image \
  --n-x-pixels 128 \
  --n-y-pixels 128 \
  --datatype int16 \
  --frame-rate 100 \
  --runtime 60 \
  --disable-curses