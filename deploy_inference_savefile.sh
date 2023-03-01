#!/bin/bash

SAVE_PATH=./output
mkdir -p $SAVE_PATH

echo "deploying a file saver for inferencing results"
docker run -d \
--name pva-infer-save \
--network host \
--volume $SAVE_PATH:/data \
--entrypoint pvapy-hpc-consumer \
classicblue/ptychonn:0.5.3 \
  --input-channel collector:1:output \
  --output-channel file:*:output \
  --control-channel file:*:control \
  --status-channel file:*:status \
  --processor-class pvapy.hpc.adOutputFileProcessor.AdOutputFileProcessor \
  --processor-args '{"outputDirectory" : "/data", "outputFileNameFormat" : "bdp_{uniqueId:06d}.{processorId}.tiff"}' \
  --n-consumers 4 \
  --report-period 10 \
  --server-queue-size 10000 \
  --monitor-queue-size 10000 \
  --distributor-updates 1 \
  --disable-curses