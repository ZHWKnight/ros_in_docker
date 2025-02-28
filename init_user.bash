#!/bin/bash

CONTAINER_NAME="ros1_noetic"

if docker ps --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
  echo "ros docker container: $CONTAINER_NAME has inited..."
else
  echo "now init docker container $CONTAINER_NAME..."
  docker run -it \
    --name=$CONTAINER_NAME \
    --user=$(id -u $USER):$(id -g $USER) \
    --env="ROS_IN_DOCKER=1" \
    --network host \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="$HOME/Worksp/ros1_ws:$HOME/Worksp/ros1_ws:rw" \
    --workdir="$HOME/Worksp" \
    osrf/ros:noetic-desktop-full \
    bash
fi
