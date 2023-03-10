FROM ctu-iig/tx2-ros2-docker:latest
USER nvidia

RUN sudo apt-get update && sudo apt-get -y upgrade

RUN  echo 'alias ranger='"'"'ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'"'"'' >> ~/.bashrc
# RUN ranger --copy-config=all
RUN echo 'export VISUAL=vim' >> ~/.bashrc 
RUN echo 'export EDITOR=vim' >> ~/.bashrc
RUN sed -i 's/alias ll='"'"'ls -alF'"'"'/alias ll='"'"'ls -lhF'"'"'/g' ~/.bashrc

COPY ./appconfig/tmux/dottmux.conf /home/nvidia/.tmux.conf


# RUN mkdir -p /home/nvidia/tmp/ranger
# COPY ./appconfig/ranger /home/nvidia/tmp/ranger
# WORKDIR /home/nvidia/tmp/ranger/
# RUN ls /home/nvidia/tmp
# RUN ./install.sh --unattended

# WORKDIR /home/nvidia
# RUN rm -rf /home/nvidia/tmp/

