#!/usr/bin/env bash

set -e

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

cd ${SCRIPTPATH}/f1tenth-docker/l4t-base
make image_r32

cd ${SCRIPTPATH}/f1tenth-docker
docker build -t ctu-f1t/tx2-ros2:humble .

RM_ID=$(docker ps -a | grep ctu-f1t/l4t-cuda:r32.7.2-u22 | head -n1 | awk '{print $1;}')
docker rm $RM_ID
RM_ID=$(docker images | grep ctu-f1t/l4t-cuda:r32.7.2-u22 | head -n1 | awk '{print $3;}')
docker rmi $RM_ID
