FROM ctu-iig/tx2-ros2-docker:latest
USER nvidia

# RUN add-apt-repository ppa:deadsnakes/ppa
# RUN apt-get update
# RUN apt-get install -y python3.9
# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 20
# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
# RUN update-alternatives --set python3 /usr/bin/python3.9

# # setup environment
# RUN mkdir -p /home/nvidia/git
# WORKDIR /home/nvidia/git
# RUN git clone https://github.com/klaxalk/linux-setup.git
# WORKDIR /home/nvidia/git/linux-setup
# RUN sed -i 's/exfat-utils/exfatprogs/g' install.sh
# RUN ./install.sh --unattended --docker

RUN sudo apt-get update

# fixes prompts during apt installations
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y -q
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get -y install keyboard-configuration

RUN sudo apt-get -y update && sudo apt-get -y install software-properties-common git

RUN mkdir -p /home/nvidia/git && cd /home/nvidia/git && git clone https://github.com/klaxalk/linux-setup --depth 1

RUN sed -i 's/exfat-utils/exfatprogs/g' /home/nvidia/git/linux-setup/install.sh
RUN cd /home/nvidia/git/linux-setup && ./install.sh --unattended --docker && rm -rf /var/lib/apt/lists/*

WORKDIR /home/nvidia
RUN rm -rf git/
# ENV HOSTNAME tx2-ros2-docker
# RUN echo $(grep $(hostname) /etc/hosts | cut -f1) tx2-ros2-docker >> /etc/hosts && install-software

# RUN update-alternatives  --set python3 /usr/bin/python3.10

