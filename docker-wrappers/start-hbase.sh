#!/bin/bash
#
# Script to start docker and update the /etc/hosts file to point to
# the hbase-docker container
#
# hbase-docker thrift and master server logs are written to the local
# logs directory
#

echo "Starting HBase container"

#remove the container if it exists
echo "Cleaning up..."
docker kill hbase-docker > /dev/null 2>&1
docker rm hbase-docker > /dev/null 2>&1

docker_args="--name=hbase-docker -h hbase-docker -d -p 9090:9090 -p 16000:16000 -p 9095:9095 -p 8080:8080"
if [[ -n $1 ]]; then
    docker_args="$docker_args -v=$1"
fi
id=$(docker run $docker_args hbase-docker)

# echo "Container has ID $id"

# # Get the hostname and IP inside the container
# docker inspect $id > config.json
# docker_hostname=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["Config"]["Hostname"])')
# docker_ip=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["NetworkSettings"]["IPAddress"])')
# rm -f config.json

# echo "Container IP is $docker_ip"
# echo "Container hostname is $docker_hostname"