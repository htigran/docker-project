#!/bin/bash
#
# Script to stop docker

echo "Stopping hbase-docker container"
# docker stop hbase-docker
docker kill hbase-docker

echo "Removing hbase-docker container"
docker rm hbase-docker
