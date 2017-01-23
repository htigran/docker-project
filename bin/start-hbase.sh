#!/bin/bash
#
# Script to start docker and update the /etc/hosts file to point to
# the hbase-docker container
#
# hbase-docker thrift and master server logs are written to the local
# logs directory
#

echo "Starting HBase container"
data_dir=$PWD/data/hbase
sudo rm -rf $data_dir
mkdir -p $data_dir

#remove the container if it exists
echo "Cleaning up..."
docker kill hbase-docker >> /dev/null 2>&1
docker rm hbase-docker >> /dev/null 2>&1

id=$(docker run --name=hbase-docker -h hbase-docker -d -v $data_dir:/data hbase-docker)

echo "Container has ID $id"

# Get the hostname and IP inside the container
docker inspect $id > config.json
docker_hostname=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["Config"]["Hostname"])')
docker_ip=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["NetworkSettings"]["IPAddress"])')
rm -f config.json

echo "Updating /etc/hosts to make hbase-docker point to $docker_ip ($docker_hostname)"
if grep 'hbase-docker' /etc/hosts >/dev/null; then
  sudo sed -i.bak "s/^.*hbase-docker.*\$/$docker_ip hbase-docker $docker_hostname/" /etc/hosts
else
  sudo sh -c "echo '\n$docker_ip hbase-docker $docker_hostname' >> /etc/hosts"
fi

echo "Now connect to hbase-docker (in the container) on the standard ports"
echo "  ZK 2181, Thrift 9090, Master 16000, Region 16020"
echo ""
echo "For docker status:"
echo "$ id=$id"
echo "$ docker inspect \$id"
