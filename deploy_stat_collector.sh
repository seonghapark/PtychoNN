#!/bin/bash

echo "deploying stat collector"
docker run -d \
--name pva-stat-collector \
--network host \
--volume $(pwd):/data \
--entrypoint python3 \
classicblue/ptychonn:0.5.5 \
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
  --channel-name "processor:11:status" \
  --channel-name "processor:12:status" \
  --channel-name "processor:13:status" \
  --channel-name "processor:14:status" \
  --channel-name "processor:15:status" \
  --channel-name "processor:16:status" \
  --channel-name "processor:17:status" \
  --channel-name "processor:18:status" \
  --channel-name "processor:19:status" \
  --channel-name "processor:20:status" \
  --channel-name "processor:21:status" \
  --channel-name "processor:22:status" \
  --channel-name "processor:23:status" \
  --channel-name "processor:24:status" \
  --channel-name "processor:25:status" \
  --channel-name "processor:26:status" \
  --channel-name "processor:27:status" \
  --channel-name "collector:1:status"