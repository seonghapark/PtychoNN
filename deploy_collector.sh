#!/bin/bash

echo "deploying inference collector"
docker run -d \
--name pva-infer-collector \
--network host \
--entrypoint pvapy-hpc-collector \
classicblue/ptychonn:0.5.3 \
  --collector-id 1 \
  --producer-id-list "range(1,10,1)" \
  --input-channel processor:*:output \
  --control-channel collector:*:control \
  --status-channel collector:*:status \
  --output-channel collector:*:output \
  --processor-class pvapy.hpc.userDataProcessor.UserDataProcessor \
  --report-period 5 \
  --server-queue-size 10000 \
  --collector-cache-size 1 \
  --monitor-queue-size 2000 \
  --disable-curses