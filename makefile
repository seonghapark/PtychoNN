VERSION?=0.0.0
docker:
	docker buildx build --file Dockerfile.amd64 --platform linux/amd64 -t classicblue/ptychonn:${VERSION}-ml-amd64 --push .

infra:
	./deploy_mirror_server.sh
	./deploy_inference_collector.sh
	./deploy_inference_savefile.sh ./output

cinfra:
	docker rm -f pva-mirror-server \
	  pva-infer-collector \
	  pva-infer-save

N_INFERENCE?=1
infer:
	./deploy_inference.sh ${N_INFERENCE}

clean: cinfra 