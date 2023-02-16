VERSION?=0.0.0
docker:
	docker buildx build --file Dockerfile.amd64 --platform linux/amd64 -t classicblue/ptychonn:${VERSION}-ml-amd64 --push .