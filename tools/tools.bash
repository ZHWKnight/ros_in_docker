#!/bin/bash

function ask_yes_no() {
  local prompt="$1"
  local default="${2:-}"

  while true; do
    read -p "$prompt default is $default (Yes/no): " answer
    case "${answer:-$default}" in
    [Yy] | [Yy][Ee][Ss])
      echo "true"
      local result="true"
      break
      ;;
    [Nn] | [Nn][Oo])
      echo "false"
      local result="false"
      break
      ;;
    *)
      echo "Please answer Yes/no" >&2
      ;;
    esac
  done

  echo "INFO: User selected: $result" >&2
}

function select_ros_distro() {
  local ros_distros=("noetic" "humble" "jazzy")

  echo "Please select a ROS LTS distro:" >&2
  select ros_distro in "${ros_distros[@]}"; do
    [ -n "$ros_distro" ] && break
    echo "Invalid selection" >&2
  done
  echo "INFO: Selected ROS distro: $ros_distro" >&2
  printf '%s' "$ros_distro"
}

function build_container_name() {
  local default_prefix=ros_$1

  read -p "Enter a container identifier if you want (${default_prefix}_<id>): " user_input >&2
  if [ -z "$user_input" ]; then
    container_name=${default_prefix}
  else
    container_name="${default_prefix}_${user_input}"
  fi

  printf '%s' "$container_name"
}

function list_ros_containers() {
  local container_names=$(docker ps -a --filter "name=^ros_" --format '{{.Names}}')

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
