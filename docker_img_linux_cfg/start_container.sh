#!/usr/bin/env bash

mkdir -p ~/.tmuxinator
cp -r ~/f1tenth-ros2-setup/docker_img_linux_cfg/appconfig/tmux ~/.tmuxinator/

docker run -it -d \
--network=host \
--restart always \
-h tx2-ros2-docker \
--name tx2-ros2-cfg \
--device=/dev/tty.imu \
--device=/dev/tty.vesc \
--device=/dev/tty.teensy \
-v $HOME/.tmuxinator:/home/nvidia/.tmuxinator \
-v $HOME/f1tenth:/home/nvidia/f1tenth \
ctu-iig/tx2-ros2-docker-cfg:latest
