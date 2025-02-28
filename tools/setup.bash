#!/bin/bash

sudo chown `whoami` -R $HOME

tee $HOME/.bashrc  <<-'EOF' > /dev/null
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export USER=`whoami`

source /opt/ros/noetic/setup.bash
source $HOME/Worksp/ros1_ws/devel/setup.bash
EOF

sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo tee /etc/apt/sources.list.d/ubuntu.sources  <<-'EOF' > /dev/null

Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: focal focal-updates focal-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: focal-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF

sudo gpg --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo gpg --export C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 | sudo tee /usr/share/keyrings/ros.gpg > /dev/null
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/ros.gpg] https://mirrors.ustc.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list'

sudo apt update
sudo apt install iputils-ping wget curl vim git cmake build-essential python3-catkin-tools python3-rosdep

cd ~/Worksp/ros1_ws/
catkin init
catk build