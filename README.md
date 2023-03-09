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

## 5. Setup Docker environment
To use ROS2 Humble we need to set up a Docker image with Ubuntu 22.04 LTS
```bash
sudo usermod -a -G docker nvidia
sudo reboot
```