#!/bin/bash

CONTAINER_NAME="ros1_noetic"

if docker ps --filter "name=$CONTAINER_NAME" | grep -q "$CONTAINER_NAME"; then
  echo "ros docker container: $CONTAINER_NAME has inited..."
else
  echo "now init docker container $CONTAINER_NAME..."
  docker run -itd \
    --name=$CONTAINER_NAME \
    --env="ROS_IN_DOCKER=1" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --workdir="$HOME" \
    --network host \
    --ipc="host" \
    --restart=unless-stopped \
    osrf/ros:noetic-desktop-full \
    bash
fi
