FROM ctu-iig/tx2-ros2-docker:latest
USER nvidia

RUN sudo apt-get update && sudo apt-get -y upgrade

RUN  echo 'alias ranger='"'"'ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'"'"'' >> ~/.bashrc
# RUN ranger --copy-config=all
RUN echo 'export VISUAL=vim' >> ~/.bashrc 
RUN echo 'export EDITOR=vim' >> ~/.bashrc
RUN sed -i 's/alias ll='"'"'ls -alF'"'"'/alias ll='"'"'ls -lhF'"'"'/g' ~/.bashrc

RUN mkdir -p /home/nvidia/.tmuxinator/tmux_config/

COPY ./appconfig/tmux/tmux_config/dottmux.conf /home/nvidia/.tmuxinator/tmux_config/dottmux.conf
RUN tmuxinator new car
COPY ./appconfig/tmux/car.yml  /home/nvidia/.tmuxinator/car.yml
COPY ./appconfig/tmux/help/tmux_shortcuts.md /home/nvidia/.tmuxinator/help/tmux_shortcuts.md
# COPY ./appconfig/tmux  /home/nvidia/.tmuxinator

RUN sudo chown -R nvidia ~/.tmuxinator/
RUN sudo chgrp -R nvidia ~/.tmuxinator/

# RUN sudo service ssh start

# RUN echo 'if command -v tmuxinator start car &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then' >> ~/.bashrc
# RUN echo "\texec tmuxinator start car" >> ~/.bashrc
# RUN echo 'fi' >> ~/.bashrc

CMD ["sudo", "/usr/sbin/sshd", "-D"]
# CMD ["tmuxinator", "start", "car"]
# RUN mkdir -p /home/nvidia/tmp/ranger
# COPY ./appconfig/ranger /home/nvidia/tmp/ranger
# WORKDIR /home/nvidia/tmp/ranger/
# RUN ls /home/nvidia/tmp
# RUN ./install.sh --unattended

# WORKDIR /home/nvidia
# RUN rm -rf /home/nvidia/tmp/

