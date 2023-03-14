#!/usr/bin/env bash

docker build -t ctu-iig/tx2-ros2-docker:latest ../docker_img_plain/
docker build -t ctu-iig/tx2-ros2-docker-cfg:latest .