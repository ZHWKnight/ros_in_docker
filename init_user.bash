#!/bin/bash

CONTAINER_NAME="ros1_noetic"

if docker ps --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
  echo "ros docker container: $CONTAINER_NAME has inited..."
else
  echo "now init docker container $CONTAINER_NAME..."
  docker run -itd \
    --name=$CONTAINER_NAME \
    --env="ROS_IN_DOCKER=1" \
    --user=$(id -u $USER):$(id -g $USER) \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="$HOME/Worksp/ros1_ws:$HOME/Worksp/ros1_ws:rw" \
    --workdir="$HOME" \
    --network host \
    --ipc="host" \
    --restart=unless-stopped \
    osrf/ros:noetic-desktop-full \
    bash
fi
