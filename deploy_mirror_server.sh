#!/bin/bash

echo "deploying a mirror server"
docker run -d \
  --name pva-mirror-server \
  --network host \
  --entrypoint pvapy-mirror-server \
  classicblue/ptychonn:0.5.4 \
  --channel-map "(pvapy:image,dp_eiger_xrd4:Pva1:Image,pva,20000)"
