# https://hub.docker.com/_/ubuntu/
# FROM ros:humble

# RUN apt-get update 
# RUN apt-get install -y \
# 	ros-humble-rviz2

FROM ubuntu:22.04

ENV TERM="xterm-256color"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=0

RUN apt-get update
RUN bash -c "yes | unminimize"

RUN apt-get upgrade -y
RUN apt-get install -y \
	locales \
	apt-utils

RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TZ Europe/Prague
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# RUN echo -en '\nnameserver 8.8.8.8\nnameserver 8.8.4.4' >> /etc/resolv.conf
# RUN sed -ci '1s/^/nameserver 8.8.4.4\n/' /etc/resolv.conf

RUN apt-get install -y --fix-missing \
	curl wget git gcc g++ clang make valgrind zip iputils-ping \
	man-db \
	cmake \
    openssh-server \
	vim \
	ranger \
	software-properties-common \
	sudo \
	iproute2 \
	tmux \
	tmuxinator \
	git \
	openssh-server \
	build-essential

RUN add-apt-repository universe
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt-get update

RUN apt-get install -y \
	python3-colcon-common-extensions \
	python3-colcon-mixin \
	python3-flake8 \
	python3-pip \
	python3-pytest-cov \
	python3-rosdep \
	python3-setuptools \
	python3-vcstool \
	python3-rosinstall-generator 


RUN apt-get install -y ros-humble-desktop

RUN rosdep init

RUN mkdir /var/run/sshd
RUN echo 'root:nvidia' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed -i 's/\(^Port\)/#\1/' /etc/ssh/sshd_config && echo Port 2233 >> /etc/ssh/sshd_config
EXPOSE 2233


RUN useradd --create-home --shell /bin/bash nvidia && echo "nvidia:nvidia" | chpasswd && adduser nvidia sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# RUN usermod -aG sudo nvidia


USER nvidia
WORKDIR /home/nvidia

RUN rosdep update

# add default mixins repository and download the mixins from it
# see https://github.com/colcon/colcon-mixin-repository/
RUN colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && colcon mixin update default


CMD ["sudo", "/usr/sbin/sshd", "-D"]
