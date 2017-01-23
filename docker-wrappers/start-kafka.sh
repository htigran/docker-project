#!/bin/bash
#
# Script to start docker and update the /etc/hosts file to point to
# the kafka-docker container
#
# kafka-docker thrift and master server logs are written to the local
# logs directory
#

echo "Starting Kafka container"

#remove the container if it exists
# echo "Cleaning up..."
docker kill kafka-docker > /dev/null 2>&1
docker rm kafka-docker > /dev/null 2>&1

ip=`hostname --ip-address`
docker_args="--name=kafka-docker -h kafka-docker -d -p 9092:9092 -p 2181:2181 -e KAFKA_ADVERTISED_HOST_NAME=$ip"
if [[ -n $1 ]]; then
    docker_args="$docker_args -v=$1"
fi
if [[ -n $2 ]]; then
    docker_args="$docker_args -e KAFKA_CREATE_TOPICS=$2"
fi
id=$(docker run $docker_args kafka-docker)
# echo "Container has ID $id"

# Get the hostname and IP inside the container
# docker inspect $id > config.json
# docker_hostname=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["Config"]["Hostname"])')
# docker_ip=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["NetworkSettings"]["IPAddress"])')
# rm -f config.json

# echo "Container IP is $docker_ip"
# echo "Container hostname is $docker_hostname"
