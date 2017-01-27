#!/bin/bash
#
# Script to start docker and update the /etc/hosts file to point to
# the kafka-docker container
#
# kafka-docker thrift and master server logs are written to the local
# logs directory
#

source config.sh
echo "Starting $kafka_docker_container"
data_dir=${1:-$kafka_default_data_dir}
topics=$2

#remove the container if it exists
echo "Cleaning up..."
running=$(docker ps | grep " $kafka_docker_container ")
if [ ! -z "$running" ]; then
    docker kill $kafka_docker_container >> /dev/null 2>&1
    docker rm $kafka_docker_container >> /dev/null 2>&1
fi

ip=`hostname --ip-address`
docker_args="--name=$kafka_docker_container -h $kafka_docker_container -d -p 9092:9092 -p 2181:2181 -e KAFKA_ADVERTISED_HOST_NAME=$ip"
sudo rm -rf $data_dir && mkdir -p $data_dir
docker_args="$docker_args -v=$data_dir:/data"

if [[ -n $topics ]]; then
    docker_args="$docker_args -e KAFKA_CREATE_TOPICS=$topics"
fi
id=$(docker run $docker_args $kafka_docker_image)

echo "Container has ID $id"

# Get the hostname and IP inside the container
docker inspect $id > config.json
docker_hostname=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["Config"]["Hostname"])')
docker_ip=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["NetworkSettings"]["IPAddress"])')
rm -f config.json

echo "Updating /etc/hosts to make $kafka_docker_container point to $docker_ip ($docker_hostname)"
if grep '$kafka_docker_container' /etc/hosts >/dev/null; then
  sudo sed -i.bak "s/^.*$kafka_docker_container.*\$/$docker_ip $kafka_docker_container $docker_hostname/" /etc/hosts
else
  sudo sh -c "echo '\n$docker_ip $kafka_docker_container $docker_hostname' >> /etc/hosts"
fi

echo "Waiting until $kafka_docker_container is ready"
while [ ! -f $data_dir/done ];
do
    sleep 1;
done;

echo "Now connect to $kafka_docker_container (in the container) on the standard ports"
echo "  ZK 2181, Kafka 9092"
echo ""
echo "For docker status:"
echo "$ id=$id"
echo "$ docker inspect \$id"
