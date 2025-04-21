#!/bin/bash

function select_ros_version() {
  local ros_versions=("noetic" "humble" "jazzy")

  echo "Please select a ROS version:"
  select ros_version in ${ros_versions[@]}; do
    if [[ -n "$ros_version" ]]; then
      echo "You selected ROS version is: $ros_version"
      break
    else
      echo "Invalid selection. Please choose a valid ROS version."
    fi
  done

  local default_prefix=ros_${ros_version}

  read -p "Enter a container identifier (press Enter to use default: ${default_prefix}): " user_input

  if [ -z "$user_input" ]; then
    container_name=${default_prefix}
  else
    container_name="${default_prefix}_${user_input}"
  fi

  echo $container_name
}

function list_ros_containers() {
  local container_names=$(docker ps --filter "name=^ros_" --format '{{.Names}}')
  if [ -z "$container_names" ]; then
    echo "No containers found with name starting with 'ros_'."
    exit 1
  else
    num_containers=$(echo "$container_names" | wc -l)
    if [ "$num_containers" -eq 1 ]; then
      local container_name=$container_names
      echo "Found only one ros container: $container_name"
    elif [ "$num_containers" -gt 1 ]; then
      echo "Multiple ros containers found:"
      select container_name in $container_names; do
        if [ -n "$container_name" ]; then
          echo "You selected container: $container_name"
          break
        else
          echo "Invalid selection. Please choose a valid container."
        fi
      done
    fi
  fi

  echo $container_name
}
