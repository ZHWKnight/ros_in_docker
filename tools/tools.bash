#!/bin/bash

function select_ros_version() {
  local ros_versions=("noetic" "humble" "jazzy")

  echo "Please select a ROS version:" >&2
  select ros_version in "${ros_versions[@]}"; do
    # if [[ -n "$ros_version" ]]; then
    #   echo "You selected ROS version: $ros_version" >&2
    #   break
    # else
    #   echo "Invalid selection" >&2
    # fi
    [ -n "$ros_version" ] && break
    echo "Invalid selection" >&2
  done
  echo "INFO: Selected ROS version: $ros_version" >&2

  local default_prefix=ros_${ros_version}

  read -p "Enter a container identifier (press Enter to use default: ${default_prefix}): " user_input >&2
  if [ -z "$user_input" ]; then
    container_name=${default_prefix}
  else
    container_name="${default_prefix}_${user_input}"
  fi

  printf '%s' "$container_name"
}

function list_ros_containers() {
  local container_names=$(docker ps --filter "name=^ros_" --format '{{.Names}}')

  if [ -z "$container_names" ]; then
    echo "ERROR: No containers found, docker ros container's name starting with 'ros_'." >&2
    exit 1
  fi

  local num_containers=$(echo "$container_names" | wc -l)
  local container_name

  if [ "$num_containers" -eq 1 ]; then
    container_name=$container_names
    echo "Found single container: $container_name" >&2
  else
    echo "Multiple ros containers found:" >&2
    select container_name in $container_names; do
      [ -n "$container_name" ] && break
      echo "WARN: Invalid selection" >&2
    done
    echo "Selected $container_name" >&2
  fi

  printf '%s' "$container_name"
}
