#!/bin/bash

echo "deploying inference collector"
docker run -d \
--name pva-stat-collector \
--network host \
--volume $(pwd):/data \
--entrypoint python3 \
classicblue/ptychonn:0.5.1 \
  /app/stat-exporter.py \
  --output-filepath "/data/output/stat.txt" \
  --channel-name "processor:1:status" \
  --channel-name "processor:2:status" \
  --channel-name "processor:3:status" \
  --channel-name "processor:4:status" \
  --channel-name "processor:5:status" \
  --channel-name "processor:6:status" \
  --channel-name "processor:7:status" \
  --channel-name "processor:8:status" \
  --channel-name "processor:9:status" \
  --channel-name "processor:10:status" \
  --channel-name "collector:1:status"