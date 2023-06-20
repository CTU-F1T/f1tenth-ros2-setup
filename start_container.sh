#!/usr/bin/env bash

mkdir -p ~/.tmuxinator
cp -r ~/f1tenth-ros2-setup/f1tenth-docker/appconfig/tmux/* ~/.tmuxinator/

docker run -it -d \
--network=host \
--restart always \
-h tx2-ros2 \
--name tx2-ros2-cuda \
--gpus all \
-v $HOME/.tmuxinator:/home/nvidia/.tmuxinator \
-v $HOME/f1tenth:/home/nvidia/f1tenth \
-v /dev:/dev \
--runtime nvidia \
--device-cgroup-rule='c 166:* rmw' \
-e ROS_DOMAIN_ID=1 \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
ctu-f1t/tx2-ros2:humble



# --device=/dev/tty.imu \
# --device=/dev/tty.vesc \
# --device=/dev/tty.teensy \
