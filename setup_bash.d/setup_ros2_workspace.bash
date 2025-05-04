#!/bin/bash

privilege_command=$(
  cat <<EOF
apt-get install -y python3-colcon-common-extensions
EOF
)
if [ "$EUID" -eq 0 ]; then
  eval "$privilege_command"
else
  sudo bash -c "$privilege_command"
fi

source /opt/ros/$ROS_DISTRO/setup.bash
ros_ws_dir=${1:-"$HOME/Worksp/ros2_ws"}
mkdir -p $ros_ws_dir/src && cd $ros_ws_dir
# git clone https://github.com/ros2/examples.git src/ros2_examples --branch $ROS_DISTRO --depth 1
# if [[ $? -ne 0 ]]; then
#   git clone https://ghfast.top/https://github.com/ros2/examples.git src/ros2_examples --branch $ROS_DISTRO --depth 1
# fi
colcon build --symlink-install

tee --append $HOME/.bashrc <<EOF >/dev/null
# ROS2
source /opt/ros/$ROS_DISTRO/setup.bash
source $ros_ws_dir/install/setup.bash
source /usr/share/colcon_cd/function/colcon_cd.sh
export _colcon_cd_root=/opt/ros/jazzy/
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
EOF
source $HOME/.bashrc
