#!/bin/bash

sudo chown `whoami` -R $HOME

tee $HOME/.bashrc  <<-'EOF' > /dev/null
# COMMON
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export USER=`whoami`
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
sudo apt install -y \
    iputils-ping \
    wget \
    curl \
    iproute2 \
    vim \
    git \
    cmake \
    build-essential \
    python3-catkin-tools \
    python3-osrf-pycommon \
    python3-rosdep \
    ;

sudo apt install -y bash-completion
tee $HOME/.bashrc  <<-'EOF' > /dev/null --append
# BASH-COMPLETION
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
EOF

cd ~/Worksp/ros1_ws/
catkin init
tee $HOME/.bashrc  <<-'EOF' > /dev/null --append
# ROS1
source /opt/ros/noetic/setup.bash
source $HOME/Worksp/ros1_ws/devel/setup.bash
EOF

. $HOME/.bashrc
