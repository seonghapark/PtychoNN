#!/bin/bash

set -x

CONSUMER_ID=$1
N_CONSUMERS=$2

docker rm -f pva-consumer-$CONSUMER_ID

docker run -d \
  --name pva-consumer-$CONSUMER_ID \
  --network host \
  --runtime nvidia \
  --shm-size 32G \
  --entrypoint pvapy-hpc-consumer \
  classicblue/ptychonn:0.5.4-ml-amd64 \
  --input-channel pvapy:waggle1 \
  --consumer-id $CONSUMER_ID \
  --control-channel processor:*:control \
  --status-channel processor:*:status \
  --output-channel processor:*:output \
  --processor-file /app/inferPtychoNNImageProcessor.py \
  --processor-class InferPtychoNNImageProcessor \
  --processor-args '{"onnx_mdl": "/app/model_512_fp16.trt", "output_x": 64, "output_y": 64, "net": "wan0"}' \
  --report-period 5 \
  --n-consumers $N_CONSUMERS \
  --server-queue-size 100 \
  --monitor-queue-size 1000 \
  --distributor-updates 8 \
  --disable-curses

# METRICS_ARGS=$(docker inspect -f '--processor-id {{.State.Pid}} --docker-id {{.Id}}' pva-consumer-$CONSUMER_ID)

# echo $METRICS_ARGS

# echo "deploying metrics collector"
# docker run -d \
# --name pva-metrics-collector \
# --network host \
# --runtime nvidia \
# --volume /sys/fs/cgroup:/host/sys/fs/cgroup:ro \
# --entrypoint python3 \
# classicblue/ptychonn:0.5.2-ml-amd64 \
#   /app/metrics-collector.py \
#   --output-channel processor:$CONSUMER_ID:metric
#   $METRICS_ARGS