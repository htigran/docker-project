#!/bin/bash
#
# Script to stop docker

source config.sh

echo "Stopping $hbase_docker_container container"

running=$(docker ps | grep " $hbase_docker_container ")
if [ ! -z "$running" ]; then
    # docker stop hbase-docker
    docker kill $hbase_docker_container

    echo "Removing data folder"
    rm -fr data/hbase

    echo "Removing hbase-docker container"
    docker rm $hbase_docker_container
fi