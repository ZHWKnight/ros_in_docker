#!/bin/bash

. "tools/tools.bash"

container_name=$(select_ros_version)

if docker ps --filter "name=$container_name" | grep -q "$container_name"; then
  echo "ros docker container: already $container_name has initilized..."
else
  echo "now initilize docker container $container_name..."

  DOCKER_ROS_X11=${DOCKER_ROS_X11:-true}
  DOCKER_ROS_ROOTLESS=${DOCKER_ROS_ROOTLESS:-true}
  DOCKER_ROS_GPU=${DOCKER_ROS_GPU:-true}

  docker_cmd="docker run -itd"

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

  if [ $DOCKER_ROS_ROOTLESS == true ]; then
    docker_cmd="$docker_cmd \
      --user=$(id -u):$(id -g) \
      --volume='/etc/group:/etc/group:ro' \
      --volume='/etc/passwd:/etc/passwd:ro' \
      --volume='/etc/shadow:/etc/shadow:ro' \
      --volume='/etc/sudoers.d:/etc/sudoers.d:ro'"
  fi

  ws_host="$HOME/Worksp/Containers/${container_name}"
  mkdir -p $ws_host
  cp -r setup_bash.d $ws_host/
  home_container=$([ "$DOCKER_ROS_ROOTLESS" == "true" ] && echo "$HOME" || echo "/root")
  ws_container=$home_container/Worksp/

  docker_cmd="$docker_cmd \
    --name=$container_name \
    --env='ROS_CONTAINER_NAME=$container_name' \
    --volume='$ws_host:$ws_container:rw' \
    --workdir='$home_container' \
    --network host \
    --ipc='host' \
    --restart=unless-stopped \
    osrf/ros:$ros_version-desktop-full \
    bash"
  eval $docker_cmd

  if [ $DOCKER_ROS_ROOTLESS == true ]; then docker exec $container_name sudo chown -R $(id -u):$(id -g) $HOME; fi
  docker cp setup_bash.d $container_name:$home_container/
  docker exec $container_name bash setup_bash.d/setup.bash
fi
