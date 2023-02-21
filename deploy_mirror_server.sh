#!/bin/bash

echo "deploying a mirror server"
docker run -d --rm \
	--name pva-mirror-server \
	--network host \
	--entrypoint pvapy-mirror-server \
	classicblue/ptychonn:0.2.1 \
	--channel-map "(pvapy:image,ad:image,pva,2000)"
