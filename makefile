VERSION?=0.0.0
docker:
	docker buildx build --file Dockerfile.amd64 --platform linux/amd64 -t classicblue/ptychonn:${VERSION}-ml-amd64 --push .

infra:
	./deploy_mirror_server.sh
	

infer:
	./deploy.sh 1

clean:
	docker rm -f pva-mirror-server