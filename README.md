# AUTO GO BRRR

## 1. Flash NVIDIA Jetson TX2 (8GB):

**You need Ubuntu 18.04 LTS on your computer (VM or Docker is sufficient) to flash the Nvidia**
[L4T and JetPack](https://github.com/pokusew/ros-setup/blob/main/nvidia-jetson-tx2/L4T.md)

* Install [NVIDIA SDK Manager](https://developer.nvidia.com/drive/sdk-manager)
    * [Docker Guide](https://github.com/atinfinity/sdk_manager_docker)
    * When using VM, be sure that you can access the needed USB port
* **You need approx 30GB of free space to download needed files** - you can use an external disk but it needs to be formatted to ext4 (if using docker, you need to mount it)
* Connect to NVIDIA Jetson with a USB cable and, the SDK Manager and follow the [installation guide](https://connecttech.com/resource-center/kdb373/) for Orbitty Carrier
    * if the flashing doesn't work just try to restart the board (hold the power button until the sys control LED turns off and then turn off the power)
* Try to connect via ssh (with the board still connected via USB), but if it doesn't work (connection refused), you need to connect via UART and configure the system - ask someone for the  USB/UART converter (the device name is probably /dev/ttyAMC0 on Linux devices and the rate is 115200).
* Optional but recommended: Then you can run SDK manager again and install **just** Jetson SDK Components - if the board is connected to ethernet, use its IP address instead of the newly assigned one, it should be quicker

## 2. Upgrade Ubuntu
```bash
sudo apt update
sudo apt upgrade
```

## 3. Setup UDEV
* [Guide](https://github.com/pokusew/ros-setup/blob/main/nvidia-jetson-tx2/UDEV.md)
* You can now connect the USB hub and you should see i.e. /dev/tty.teensy (if connected)

## 4. Configure network devices
* [Guide](https://github.com/pokusew/ros-setup/blob/main/nvidia-jetson-tx2/NETWORK.md#setup)
* **&#9432;** In section 1.c change the ipv4.address to 192.168.<random number from 0-255>.1/24

## 5. Setup Docker environment
To use ROS2 Humble we need to set up a Docker image with Ubuntu 22.04 LTS
```bash
sudo usermod -a -G docker nvidia
sudo reboot
```

* Download [f1tenth rewrite](https://github.com/pokusew/f1tenth-rewrite) repo to the car's home and rename it to `f1tenth`
    ```bash
    git clone https://github.com/pokusew/f1tenth-rewrite.git
    mv f1tenth-rewrite f1tenth
    ````

* You need to build the docker image on the car, so there is no problem with the system version
* First, clone this git repo to the car and run available scripts
    ```bash
    git clone git@github.com:cihlami1/f1tenth-ros2-setup.git
    cd f1tenth-ros2-setup/docker_img_linux_cfg
    ./build.sh
    ```
* This will take a while, because we need to install all of ROS 2 Humble packages
* After the build, you need to start a docker container
* **You have to connect all the devices (vesc, imu, teensy) before running the script, otherwise the container won't start**
* Then just run the start script
    ```bash
    ./start_container.sh
    ```
* Now the docker container should be running
* If the start of the container failed or you can't see files in the `f1tenth` folder, you need to remove the container, check your configuration and start it again. So be sure that folder `f1tenth` is correctly mounted (you can see all the files) and that all the devices are connected before developing anything or it will be removed.
* **Never remove the container after final deployment or all your data will be lost**

### Useful commands for docker
```bash
docker ps                       # list running containers
docker ps -a                    # list all containers
docker stop <container-name>    # stop running container
docker rm <container-name>      # remove stopped container
docker exec -it <container-name> bash   # run docker environment (if ssh access is not working)
```


## 6. Connect to f1tenth car via ssh
* Now, when everything should be ready and you should be able to connect to the f1tenth car's docker container via ssh from your personal computer
* The docker container uses **port 2233** for ssh connection
* Connect to the wifi created by the car and run
    ```bash
    ssh -p 2233 nvidia@<ip-addr-of-car> # put here the IP address that you selected when seting up the device in section 4
    ```
* Or you can create/edit `~/.ssh/config` file on your personal computer
    ```bash
    Host <choose-name>
        HostName <ip-addr-of-car>
        User nvidia
        Port 2233
    ```
    and then simply run `ssh <choosen-name>`