#!/bin/bash
#
# Script to stop docker

echo "Stopping kafka-docker container"
source config.sh

running=$(docker ps | grep " $kafka_docker_container ")
if [ ! -z "$running" ]; then
    # docker stop kafka-docker
    docker kill $kafka_docker_container

    echo "Removing data folder"
    rm -fr data/kafka

    echo "Removing kafka-docker container"
    docker rm $kafka_docker_container
fi