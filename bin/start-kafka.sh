#!/bin/bash
#
# Script to start docker and update the /etc/hosts file to point to
# the kafka-docker container
#
# kafka-docker thrift and master server logs are written to the local
# logs directory
#

echo "Starting Kafka container"
data_dir=$PWD/data/kafka
sudo rm -rf $data_dir
mkdir -p $data_dir

#remove the container if it exists
echo "Cleaning up..."
docker kill kafka-docker >> /dev/null 2>&1
docker rm kafka-docker >> /dev/null 2>&1

id=$(docker run --name=kafka-docker -h kafka-docker -d -v $data_dir:/data kafka-docker)

echo "Container has ID $id"

# Get the hostname and IP inside the container
docker inspect $id > config.json
docker_hostname=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["Config"]["Hostname"])')
docker_ip=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["NetworkSettings"]["IPAddress"])')
rm -f config.json

echo "Updating /etc/hosts to make kafka-docker point to $docker_ip ($docker_hostname)"
if grep 'kafka-docker' /etc/hosts >/dev/null; then
  sudo sed -i.bak "s/^.*kafka-docker.*\$/$docker_ip kafka-docker $docker_hostname/" /etc/hosts
else
  sudo sh -c "echo '\n$docker_ip kafka-docker $docker_hostname' >> /etc/hosts"
fi

echo "Now connect to kafka-docker (in the container) on the standard ports"
echo "  ZK 2181, Kafka 9092"
echo ""
echo "For docker status:"
echo "$ id=$id"
echo "$ docker inspect \$id"
