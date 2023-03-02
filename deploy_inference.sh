#!/bin/bash

N_START=$1
N_END=$2

for n in $(seq $N_START $N_END)
do
  NAME="pva-consumer-$n"
  echo "re-deploying inference $n"
  docker run -d \
  --name $NAME \
  --network host \
  --runtime nvidia \
  --shm-size 32G \
  --entrypoint pvapy-hpc-consumer \
  classicblue/ptychonn:0.5.4-ml-amd64 \
  --input-channel pvapy:image \
  --control-channel processor:$n:control \
  --status-channel processor:$n:status \
  --output-channel processor:$n:output \
  --processor-file /app/inferPtychoNNImageProcessor.py \
  --processor-class InferPtychoNNImageProcessor \
  --processor-args '{"onnx_mdl": "/app/model_512.trt", "output_x": 64, "output_y": 64}' \
  --report-period 5 \
  --server-queue-size 10000 \
  --monitor-queue-size 1000 \
  --distributor-updates 8 \
  --disable-curses
done