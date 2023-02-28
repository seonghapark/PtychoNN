VERSION?=0.0.0
N_START?=1
N_END?=1
docker:
	docker buildx build --file Dockerfile.amd64 --platform linux/amd64 -t classicblue/ptychonn:${VERSION}-ml-amd64 --push .

build:

	
infra:
	./deploy_mirror_server.sh
	./deploy_collector.sh
#	./deploy_inference_savefile.sh

cinfra:
	docker rm -f pva-mirror-server \
	  pva-infer-collector \
	  pva-stat-collector
#	  pva-infer-save

infer:
	./deploy_inference.sh ${N_START} ${N_END}

cinfer:
	docker rm -f $$(docker ps --filter name=pva-consumer-* -q)

monitor:
	./deploy_monitor.sh

cmonitor:
	docker rm -f pva-stat-monitor

clean: cinfra cinfer cmonitor
