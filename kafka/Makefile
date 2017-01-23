
IMAGE_NAME=kafka-docker
IMAGE_TAG=latest

# get the verion number from the Dockerfile
VERSION=$(shell awk '/^ENV VERSION/ {print $3}' Dockerfile)

.PHONY: build
build:
	@echo "Building hbase docker image $(VERSION)"
	@docker build -t $(IMAGE_NAME) .

push:
	@echo "Pushing image to Docker registry"
	@docker push $(IMAGE_NAME):$(IMAGE_TAG)

clean:
	@sudo rm -fr data

run: stop
	@../bin/start-kafka.sh
