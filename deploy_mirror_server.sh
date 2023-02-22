#!/bin/bash

echo "deploying a mirror server"
docker run -d \
  --name pva-mirror-server \
  --network host \
  --entrypoint pvapy-mirror-server \
  classicblue/ptychonn:0.5.0 \
  --channel-map "(pvapy:image,ad:image,pva,2000)"
