#
# this dockerfile roughly follows the 'Install ROS From Source' procedures from:
#   https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html
#
ARG BASE_IMAGE=ctu-f1t/l4t-base:r32.7.2-u22
FROM ${BASE_IMAGE}

ARG ROS_PKG=ros_base
ENV ROS_DISTRO=humble
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_PYTHON_VERSION=3

ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:/home/nvidia/.local/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL /bin/bash
SHELL ["/bin/bash", "-c"] 

ENV TERM="xterm-256color"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=0

RUN apt-get update && bash -c "yes | unminimize"

WORKDIR /tmp

# change the locale from POSIX to UTF-8
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8
ENV TZ Europe/Prague
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# set Python3 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1


# 
# add the ROS deb repo to the apt sources list
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		curl \
		wget \
		gnupg2 \
		lsb-release \
		ca-certificates \
		apt-utils \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null


# 
# install development packages
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		build-essential \
		cmake \
		git \
		libbullet-dev \
		libpython3-dev \
		python3-colcon-common-extensions \
		python3-flake8 \
		python3-pip \
		python3-numpy \
		python3-pytest-cov \
		python3-rosdep \
		python3-setuptools \
		python3-vcstool \
		python3-rosinstall-generator \
		libasio-dev \
		libtinyxml2-dev \
		libcunit1-dev \
		openssh-server \
		vim \
		ranger \
		man-db \
		software-properties-common \
		sudo \
		iproute2 \
		tmux \
		tmuxinator \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


RUN useradd --create-home --shell /bin/bash nvidia && echo "nvidia:nvidia" | chpasswd && \
	adduser nvidia sudo && \
	adduser nvidia dialout && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# USER nvidia

# install some pip packages needed for testing
RUN python3 -m pip install -U \
		argcomplete \
		flake8-blind-except \
		flake8-builtins \
		flake8-class-newline \
		flake8-comprehensions \
		flake8-deprecated \
		flake8-docstrings \
		flake8-import-order \
		flake8-quotes \
		pytest-repeat \
		pytest-rerunfailures \
		pytest

# USER root
# install gcc-8
COPY ./gcc-8 /tmp/gcc-8
RUN apt-get update && \
	apt-get install -y libasan5 && \
	apt-get install -y /tmp/gcc-8/*.deb && \
	rm -rf /tmp/gcc-8 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 10 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 20 && \
	update-alternatives --set gcc /usr/bin/gcc-8 && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 10 && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 20 && \
	update-alternatives --set g++ /usr/bin/g++-8 && \
	update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30 && \
	update-alternatives --set cc /usr/bin/gcc && \
	update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30 && \
	update-alternatives --set c++ /usr/bin/g++


ENV CC=gcc
ENV CXX=g++

# 
# install OpenCV (with CUDA)
#
# ARG OPENCV_URL=https://nvidia.box.com/shared/static/5v89u6g5rb62fpz4lh0rz531ajo2t5ef.gz
# ARG OPENCV_DEB=OpenCV-4.5.0-aarch64.tar.gz

# COPY scripts/opencv_install.sh /tmp/opencv_install.sh
# RUN cd /tmp && ./opencv_install.sh ${OPENCV_URL} ${OPENCV_DEB}

# WORKDIR /opt

# ARG OPENCV_VERSION="4.7.0"

# # install build dependencies
# COPY scripts/opencv_install_deps.sh opencv_install_deps.sh
# RUN ./opencv_install_deps.sh

# # OpenCV looks for the cuDNN version in cudnn_version.h, but it's been renamed to cudnn_version_v8.h
# RUN ln -s /usr/include/$(uname -i)-linux-gnu/cudnn_version_v8.h /usr/include/$(uname -i)-linux-gnu/cudnn_version.h && \
# 	ln -s /usr/include/$(uname -i)-linux-gnu/cudnn_v8.h /usr/include/$(uname -i)-linux-gnu/cudnn.h

# # architecture-specific build options
# ARG CUDA_ARCH_BIN=""
# ARG ENABLE_NEON="OFF"

# # COPY ./scripts/lapack.patch /tmp/lapack.patch

# # clone and configure OpenCV repo
# RUN git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv.git && \
#     git clone --depth 1 --branch ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git && \
#     cd opencv && \
#     mkdir build && \
#     cd build && \
#     echo "configuring OpenCV ${OPENCV_VERSION}, CUDA_ARCH_BIN=${CUDA_ARCH_BIN}, ENABLE_NEON=${ENABLE_NEON}" && \
#     cmake \
#         -D CPACK_BINARY_DEB=ON \
# 	   -D BUILD_EXAMPLES=OFF \
#         -D BUILD_opencv_python2=OFF \
#         -D BUILD_opencv_python3=ON \
# 	   -D BUILD_opencv_java=OFF \
#         -D CMAKE_BUILD_TYPE=RELEASE \
#         -D CMAKE_INSTALL_PREFIX=/usr/local \
#         -D CUDA_ARCH_BIN=${CUDA_ARCH_BIN} \
#         -D CUDA_ARCH_PTX= \
#         -D CUDA_FAST_MATH=ON \
#         -D CUDNN_INCLUDE_DIR=/usr/include/$(uname -i)-linux-gnu \
#         -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
# 	   -D WITH_EIGEN=ON \
#         -D ENABLE_NEON=${ENABLE_NEON} \
#         -D OPENCV_DNN_CUDA=ON \
#         -D OPENCV_ENABLE_NONFREE=ON \
#         -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
#         -D OPENCV_GENERATE_PKGCONFIG=ON \
#         -D WITH_CUBLAS=ON \
#         -D WITH_CUDA=ON \
#         -D WITH_CUDNN=ON \
#         -D WITH_GSTREAMER=ON \
#         -D WITH_LIBV4L=ON \
#         -D WITH_OPENGL=OFF \
# 	   -D WITH_OPENCL=OFF \
# 	   -D WITH_IPP=OFF \
#         -D WITH_TBB=ON \
# 	   -D BUILD_TIFF=ON \
# 	   -D BUILD_PERF_TESTS=OFF \
# 	   -D BUILD_TESTS=OFF \
# 	   ../
	   
# RUN cd opencv/build && make -j$(nproc)
# RUN cd opencv/build && make install
# RUN cd opencv/build && make package

# RUN cd opencv/build && tar -czvf OpenCV-${OPENCV_VERSION}-$(uname -i).tar.gz *.deb
    

		  	  
# use pip to upgrade cmake instead because of kitware's rotating GPG keys:
# https://github.com/dusty-nv/jetson-containers/issues/216			  
#RUN wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - && \
#    apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" && \
#    apt-get update && \
#    apt-get install -y --no-install-recommends --only-upgrade \
#            cmake \
#    && rm -rf /var/lib/apt/lists/* \
#    && apt-get clean
    
# USER nvidia
RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir scikit-build && \
    pip3 install --upgrade --no-cache-dir --verbose cmake && \
    cmake --version

# USER root
#
# remove other versions of Python3
# workaround for 'Could NOT find Python3 (missing: Python3_NumPy_INCLUDE_DIRS Development'
#
RUN apt purge -y python3.9 libpython3.9* || echo "python3.9 not found, skipping removal" && \
    ls -ll /usr/bin/python*
    
    

# download/build ROS from source

# RUN mkdir -p ${ROS_ROOT}/src && \
#     cd ${ROS_ROOT} && \
#     rosinstall_generator --deps --rosdistro ${ROS_DISTRO} ${ROS_PKG} \
# 		launch_xml \
# 		launch_yaml \
# 		launch_testing \
# 		launch_testing_ament_cmake \
# 		demo_nodes_cpp \
# 		demo_nodes_py \
# 		example_interfaces \
# 		camera_calibration_parsers \
# 		camera_info_manager \
# 		cv_bridge \
# 		v4l2_camera \
# 		vision_opencv \
# 		vision_msgs \
# 		image_geometry \
# 		image_pipeline \
# 		image_transport \
# 		compressed_image_transport \
# 		compressed_depth_image_transport \
# 		> ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
#     cat ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
#     vcs import src < ros2.${ROS_DISTRO}.${ROS_PKG}.rosinstall && \
#     rm -r ${ROS_ROOT}/src/ament_cmake && \
#     git -C ${ROS_ROOT}/src/ clone https://github.com/ament/ament_cmake -b ${ROS_DISTRO} && \
#     apt-get update && \
#     cd ${ROS_ROOT} && \
#     rosdep init && \
#     rosdep update && \
#     rosdep install -y \
#     	  --ignore-src \
#        --from-paths src \
# 	  --rosdistro ${ROS_DISTRO} \
# 	  --skip-keys "libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
#     rm -rf /var/lib/apt/lists/* && \
#     apt-get clean && \
#     colcon build \
#         --merge-install \
#         --cmake-args -DCMAKE_BUILD_TYPE=Release && \
#     rm -rf ${ROS_ROOT}/src && \
#     rm -rf ${ROS_ROOT}/logs && \
#     rm -rf ${ROS_ROOT}/build && \
#     rm ${ROS_ROOT}/*.rosinstall


# RUN add-apt-repository universe && \
# 	curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
# 	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
# 	apt-get update

RUN add-apt-repository universe && \
	apt-get update && \
	apt-get install -y --fix-missing ros-humble-desktop && \
	rosdep init && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean
    

COPY ./opencv /tmp/opencv
    
# 
# upgrade cmake - https://stackoverflow.com/a/56690743
# this is needed to build some of the ROS2 packages
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  software-properties-common \
		  apt-transport-https \
		  ca-certificates \
		  gnupg \
    && rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/opencv \
    && apt-get clean


# 	apt-get remove -y  libopencv-dev opencv-data && \
# 	apt-get install -y /tmp/opencv/*.deb && \
# #
# fix broken package.xml in test_pluginlib that crops up if/when rosdep is run again
#
#   Error(s) in package '/opt/ros/foxy/build/pluginlib/prefix/share/test_pluginlib/package.xml':
#   Package 'test_pluginlib' must declare at least one maintainer
#   The package node must contain at least one "license" tag
#
#RUN TEST_PLUGINLIB_PACKAGE="${ROS_ROOT}/build/pluginlib/pluginlib_enable_plugin_testing/install/test_pluginlib__test_pluginlib/share/test_pluginlib/package.xml" && \
#    sed -i '/<\/description>/a <license>BSD<\/license>' $TEST_PLUGINLIB_PACKAGE && \
#    sed -i '/<\/description>/a <maintainer email="michael@openrobotics.org">Michael Carroll<\/maintainer>' $TEST_PLUGINLIB_PACKAGE && \
#    cat $TEST_PLUGINLIB_PACKAGE
    
    
#
# Set the default DDS middleware to cyclonedds
# https://github.com/ros2/rclcpp/issues/1335
#
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp


# 
# setup entrypoint
#
# COPY ./scripts/ros_entrypoint.sh /ros_entrypoint.sh
# RUN echo 'source /ros_entrypoint.sh' >> /root/.bashrc

#ENTRYPOINT ["/ros_entrypoint.sh"]
#CMD ["bash"]


RUN mkdir /var/run/sshd && \
	echo 'root:nvidia' | chpasswd && \
	sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
	sed -i 's/\(^Port\)/#\1/' /etc/ssh/sshd_config && echo Port 2233 >> /etc/ssh/sshd_config
EXPOSE 2233

# RUN usermod -aG sudo nvidia

RUN update-alternatives --set gcc /usr/bin/gcc-11 && \
	update-alternatives --set g++ /usr/bin/g++-11

RUN apt-get update && apt-get install -y \
	python3-colcon-mixin

COPY ./torch /tmp/torch
RUN python3 -m pip install -r /tmp/torch/requirements.txt && python3 -m pip install scikit-build ninja
RUN pip install /tmp/torch/torch-1.12.1_u22-cp310-cp310-linux_aarch64.whl \
    /tmp/torch/torchvision-0.13.1_u22-cp310-cp310-linux_aarch64.whl && \
    sudo rm -rf /tmp/torch

# RUN rosdep update

# add default mixins repository and download the mixins from it
# see https://github.com/colcon/colcon-mixin-repository/

RUN adduser nvidia video && \
	adduser nvidia audio 

USER nvidia
WORKDIR /home/nvidia

RUN sudo rosdep fix-permissions && \
	rosdep update && \
	colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && colcon mixin update default

COPY ./appconfig/.bashrc /home/nvidia/.bashrc

RUN sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get install -y htop && \
	mkdir -p /home/nvidia/.tmuxinator/tmux_config/ && \
	pip install -U numpy && \
	tmuxinator new car

COPY ./appconfig/tmux/tmux_config/dottmux.conf /home/nvidia/.tmuxinator/tmux_config/dottmux.conf
COPY ./appconfig/tmux/car.yml  /home/nvidia/.tmuxinator/car.yml
COPY ./appconfig/tmux/help/tmux_shortcuts.md /home/nvidia/.tmuxinator/help/tmux_shortcuts.md

RUN sudo chown -R nvidia ~/.tmuxinator/ && \
	sudo chgrp -R nvidia ~/.tmuxinator/

CMD ["sudo", "/usr/sbin/sshd", "-D"]

