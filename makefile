VERSION?=0.0.0
docker:
	docker buildx build --file Dockerfile.amd64 --platform linux/amd64 -t classicblue/ptychonn:${VERSION}-ml-amd64 --push .

infra:
	./deploy_mirror_server.sh
	./deploy_collector.sh
#	./deploy_inference_savefile.sh

cinfra:
	docker rm -f pva-mirror-server \
	  pva-infer-collector
#	  pva-infer-save

N_INFERENCE?=1
infer:
	./deploy_inference.sh ${N_INFERENCE}

cinfer:
	docker rm -f $$(docker ps --filter name=pva-consumer-* -q)

clean: cinfra cinfer
