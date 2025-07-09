#!/bin/bash

. "tools/tools.bash"

ros_distro=$(select_ros_distro)
container_name=$(build_container_name $ros_distro)

if docker ps --filter "name=$container_name" | grep -wq "$container_name"; then
  echo "ros docker container: already $container_name has initilized..."
else
  echo "now initilize docker container $container_name..."
fi

if [ -z "${DOCKER_ROS_PRIVILEGED+x}" ]; then
  DOCKER_ROS_PRIVILEGED=$(ask_yes_no "Enable privileged mode?" "No")
else
  DOCKER_ROS_PRIVILEGED=$([ "$DOCKER_ROS_PRIVILEGED" = "true" ] && echo "true" || echo "false")
fi

if [ -z "${DOCKER_ROS_USING_USER+x}" ]; then
  DOCKER_ROS_USING_USER=$(ask_yes_no "Enable genral user mode?" "Yes")
else
  DOCKER_ROS_USING_USER=$([ "$DOCKER_ROS_USING_USER" = "true" ] && echo "true" || echo "false")
fi

if [ -z "${DOCKER_ROS_X11+x}" ]; then
  DOCKER_ROS_X11=$(ask_yes_no "Enable X11 support?" "Yes")
else
  DOCKER_ROS_X11=$([ "$DOCKER_ROS_X11" = "true" ] && echo "true" || echo "false")
fi

if [ -z "${DOCKER_ROS_GPU+x}" ]; then
  DOCKER_ROS_GPU=$(ask_yes_no "Enable GPU support?" "Yes")
else
  DOCKER_ROS_GPU=$([ "$DOCKER_ROS_GPU" = "true" ] && echo "true" || echo "false")
fi

docker_cmd="docker run -itd"

if [ $DOCKER_ROS_PRIVILEGED == true ]; then
  docker_cmd="$docker_cmd \
    --privileged"
fi

if [ $DOCKER_ROS_USING_USER == true ]; then
  docker_cmd="$docker_cmd \
    --user=$(id -u):$(id -g) \
    --volume='/etc/group:/etc/group:ro' \
    --volume='/etc/passwd:/etc/passwd:ro' \
    --volume='/etc/shadow:/etc/shadow:ro' \
    --volume='/etc/sudoers.d:/etc/sudoers.d:ro'"
fi

if [ $DOCKER_ROS_X11 == true ]; then
  docker_cmd="$docker_cmd \
    --env='DISPLAY' \
    --env='QT_X11_NO_MITSHM=1' \
    --volume='/tmp/.X11-unix:/tmp/.X11-unix:rw'"
fi

if [ $DOCKER_ROS_GPU == true ]; then
  docker_cmd="$docker_cmd \
    --runtime=nvidia \
    --gpus all \
    --env='NVIDIA_DRIVER_CAPABILITIES=all'"
fi

ws_host="$HOME/Worksp/Containers/${container_name}"
mkdir -p $ws_host
cp -r setup_bash.d $ws_host/
home_container=$([ "$DOCKER_ROS_USING_USER" == "true" ] && echo "$HOME" || echo "/root")
ws_container=$home_container/Worksp

docker_cmd="$docker_cmd \
  --name=$container_name \
  --env='ROS_CONTAINER_NAME=$container_name' \
  --volume='$ws_host:$ws_container:rw' \
  --workdir='$home_container' \
  --network host \
  --ipc='host' \
  --restart=unless-stopped \
  osrf/ros:$ros_distro-desktop-full \
  bash"

echo "docker command: $docker_cmd"
eval $docker_cmd

if docker ps --filter "name=$container_name" --filter "status=running" | grep -wq "$container_name"; then
  if [ $DOCKER_ROS_USING_USER == true ]; then docker exec $container_name sudo chown -R $(id -u):$(id -g) $HOME; fi
  docker cp setup_bash.d $container_name:$ws_container
  docker exec $container_name bash $ws_container/setup_bash.d/setup.bash
  echo "ros docker container: $container_name has initialized successfully..."
else
  echo "ros docker container: $container_name has not been initialized successfully, please manually check the container status..."
fi
