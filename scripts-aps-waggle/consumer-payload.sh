#!/bin/bash

CONSUMER_ID=$1

docker rm -f pva-consumer-$CONSUMER_ID

docker run -d \
  --name pva-consumer-$CONSUMER_ID \
  --network host \
  --runtime nvidia \
  --shm-size 32G \
  --entrypoint pvapy-hpc-consumer \
  classicblue/ptychonn:0.5.3-ml-amd64 \
  --input-channel pvapy:waggle1 \
  --control-channel processor:$CONSUMER_ID:control \
  --status-channel processor:$CONSUMER_ID:status \
  --output-channel processor:$CONSUMER_ID:output \
  --processor-file /app/inferPtychoNNImageProcessor.py \
  --processor-class InferPtychoNNImageProcessor \
  --processor-args '{"onnx_mdl": "/app/model_512.trt", "output_x": 64, "output_y": 64}' \
  --report-period 5 \
  --server-queue-size 10000 \
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