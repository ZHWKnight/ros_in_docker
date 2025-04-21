#!/bin/bash

ros_ws_dir=${1:-"$HOME/Worksp/ros_ws"}
mkdir -p $ros_ws_dir/src && cd $ros_ws_dir

tee --append $HOME/.bashrc <<EOF > /dev/null
# ROS1
source /opt/ros/$ROS_DISTRO/setup.bash
source $ros_ws_dir/devel/setup.bash
EOF

. /opt/ros/$ROS_DISTRO/setup.bash
catkin init
