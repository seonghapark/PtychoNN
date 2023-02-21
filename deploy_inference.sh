#!/bin/bash

N_INFERENCE=$1

for n in $N_INFERENCE
do
  echo "deploying inference $n"
  docker run -d \
  --name pva-consumer-$n \
  --network host \
  --runtime nvidia \
  --shm-size 32G \
  --entrypoint pvapy-hpc-consumer \
  classicblue/ptychonn:0.3.0-ml-amd64 \
  --input-channel pvapy:image \
  --control-channel processor:$n:control \
  --status-channel processor:$n:status \
  --output-channel processor:$n:output \
  --processor-file /app/inferPtychoNNImageProcessor.py \
  --processor-class InferPtychoNNImageProcessor \
  --processor-args '{"onnx_mdl": "/app/model_128.onnx"}' \
  --report-period 10 \
  --server-queue-size 1000 \
  --monitor-queue-size 1000 \
  --distributor-updates 8 \
  --disable-curses
done
