#!/bin/bash

echo "deploying inference collector"
docker run -d \
--name pva-infer-collector \
--network host \
--entrypoint pvapy-hpc-collector \
classicblue/ptychonn:0.2.1 \
  --collector-id 1 \
  --producer-id-list "range(1,10,1)" \
  --input-channel processor:*:output \
  --control-channel collector:*:control \
  --status-channel collector:*:status \
  --output-channel collector:*:output \
  --processor-class pvapy.hpc.userDataProcessor.UserDataProcessor \
  --report-period 10 \
  --server-queue-size 1000 \
  --collector-cache-size 10000 \
  --monitor-queue-size 2000