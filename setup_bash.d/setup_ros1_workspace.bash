#!/bin/bash

privilege_command=$(
  cat <<EOF
apt-get install -y \
  build-essential \
  python3-catkin-tools \
  python3-osrf-pycommon \
  python3-rosinstall \
  python3-rosinstall-generator \
  python3-wstool \
  git \
  ;
EOF
) # 
if [ "$EUID" -eq 0 ]; then
  eval "$privilege_command"
else
  sudo bash -c "$privilege_command"
fi

source /opt/ros/$ROS_DISTRO/setup.bash
ros_ws_dir=${1:-"$HOME/Worksp/ros1_ws"}
mkdir -p $ros_ws_dir/src && cd $ros_ws_dir
# git clone https://github.com/ros/ros_tutorials.git src/ros_tutorials --branch $ROS_DISTRO-devel --depth 1
# if [[ $? -ne 0 ]]; then
#   git clone https://ghfast.top/https://github.com/ros/ros_tutorials.git src/ros_tutorials --branch $ROS_DISTRO-devel --depth 1
# fi
catkin init
catkin build

tee --append $HOME/.bashrc <<EOF >/dev/null
# ROS1
source /opt/ros/$ROS_DISTRO/setup.bash
source $ros_ws_dir/devel/setup.bash
EOF
source $HOME/.bashrc
