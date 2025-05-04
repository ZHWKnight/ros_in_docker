#!/bin/bash

echo "\$0: $0"
echo "'dirname': $(dirname $0)"
cd $(dirname $0)

if [[ -z "$ROS_DISTRO" ]]; then
  echo "ERROR: ROS_DISTRO is not set!"
  exit 1
fi

declare -A ros_distro_types=(
  ["kinetic"]="ros1"
  ["melodic"]="ros1"
  ["noetic"]="ros1"
  ["foxy"]="ros2"
  ["humble"]="ros2"
  ["iron"]="ros2"
  ["jazzy"]="ros2"
)

bash ./setup_os.bash
bash ./setup_bashrc.bash

if [[ -z "${ros_distro_types[$ROS_DISTRO]}" ]]; then
  echo "ERROR: Unsupported ROS_DISTRO: $ROS_DISTRO"
  exit 1
elif [[ "${ros_distro_types[$ROS_DISTRO]}" == "ros1" ]]; then
  echo "Configuring ROS1..."
  bash ./setup_ros1_apt_sources.bash
  bash ./setup_ros1_workspace.bash
else
  echo "Configuring ROS2..."
  bash ./setup_ros2_apt_sources.bash
  bash ./setup_ros2_workspace.bash
fi
