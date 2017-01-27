#!/bin/bash
#
# Script to start docker and update the /etc/hosts file to point to
# the hbase-docker container
#
# hbase-docker thrift and master server logs are written to the local
# logs directory
#

source config.sh

echo "Starting HBase container"
data_dir=${1:-$hbase_default_data_dir}

#remove the container if it exists
echo "Cleaning up old stuff ..."
running=$(docker ps | grep " $hbase_docker_container ")
if [ ! -z "$running" ]; then
    docker kill $hbase_docker_container >> /dev/null 2>&1
    docker rm $hbase_docker_container >> /dev/null 2>&1
fi
rm -rf $data_dir && mkdir -p $data_dir

docker_args="--name=$hbase_docker_container -h $hbase_docker_container -d -p 9090:9090 -p 16000:16000 -p 9095:9095 -p 8080:8080"
docker_args="$docker_args -v=$data_dir:/data"
id=$(docker run $docker_args $hbase_docker_image)

echo "Container has ID $id"

# Get the hostname and IP inside the container
docker inspect $id > config.json
docker_hostname=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["Config"]["Hostname"])')
docker_ip=$(python -c 'from __future__ import print_function; import json; c=json.load(open("config.json")); print(c[0]["NetworkSettings"]["IPAddress"])')
rm -f config.json

echo "Updating /etc/hosts to make $hbase_docker_container point to $docker_ip ($docker_hostname)"
if grep '$hbase_docker_container' /etc/hosts >/dev/null; then
  sudo sed -i.bak "s/^.*$hbase_docker_container.*\$/$docker_ip $hbase_docker_container $docker_hostname/" /etc/hosts
else
  sudo sh -c "echo '\n$docker_ip $hbase_docker_container $docker_hostname' >> /etc/hosts"
fi

echo "Waiting until $hbase_docker_container is ready"
while [ ! -f $data_dir/logs/done ];
do
    sleep 1;
done;

echo "Now connect to $hbase_docker_container (in the container) on the standard ports"
echo "  ZK 2181, Thrift 9090, Master 16000, Region 16020"
echo ""
echo "For docker status:"
echo "$ id=$id"
echo "$ docker inspect \$id"
