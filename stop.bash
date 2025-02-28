#!/bin/bash

xhost -local:$x11_hostname

CONTAINER_NAME="ros1_noetic"

if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
  echo "ros docker container: $CONTAINER_NAME is running..."
  docker stop $CONTAINER_NAME
fi

echo "echo ros docker container: $CONTAINER_NAME has stoped"
