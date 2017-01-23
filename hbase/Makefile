
IMAGE_NAME=hbase-docker
IMAGE_TAG=latest

# get the verion number from the Dockerfile
HBASE_VERSION=$(shell awk '/^ENV HBASE_VERSION/ {print $3}' Dockerfile)

.PHONY: build
build:
	@echo "Building hbase docker image $(HBASE_VERSION)"
	@docker build -t $(IMAGE_NAME) .

push:
	@echo "Pushing image to Docker registry"
	@docker push $(IMAGE_NAME):$(IMAGE_TAG)

clean:
	@sudo rm -fr data

run: stop
	@../bin/start-hbase.sh
