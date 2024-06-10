#!/bin/bash

## Functions
fn_exists() { declare -F "$1" > /dev/null; }

# $1 == title
do_we_continue() {
  while
    echo $1
    echo -n "Do you want to continue? (y|n)"
    read RESPONSE
    ! echo ${RESPONSE} | grep -q -E "^y|n$"
  do true; done
  if [[ ${RESPONSE} == "y" ]]; then
    return
  fi
  echo "skipping"
  false
}

read_input() {
  read -p "$1" INPUT
  echo $INPUT
}

# $1 == URL
# $2 == title
source_remote_file() {
echo "$2"
if curl --output /dev/null --silent --head --fail "$1"; then
  source <(curl -s "$1")
else
  echo "$1 is not found. Stop!"
  exit 1
fi
}
##

# Get args
while getopts f:v:n:p: flag
do
    case "${flag}" in
        f) INPUT_FILE=${OPTARG};;
        v) INPUT_VERSION=${OPTARG};;
        n) INPUT_NAME=${OPTARG};;
        p) INPUT_PORT=${OPTARG};;
    esac
done

# Ask for user input if args were not given
FILE=${INPUT_FILE:-$(read_input "Enter a file: ")}
VERSION=${INPUT_VERSION:-latest}
NAME=${INPUT_NAME:-$(read_input "Enter a container name: ")}
PORT=${INPUT_PORT}

COMMON_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/common.sh"
DISTRO_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/$FILE.sh"

## Fetching the last version of the image
#echo "Fetching the last version of $IMAGE:$VERSION"
#podman pull $IMAGE:$VERSION

## Script
source_remote_file $COMMON_SCRIPT_URL "Fetching common functions"
source_remote_file $DISTRO_SCRIPT_URL "Fetching recipe for distrobox $IMAGE"

PACKAGES_TO_INSTALL=${PACKAGES[@]:-""}

echo "Installing distrobox with name: $NAME"
echo "Packages: >${PACKAGES_TO_INSTALL}<"
! do_we_continue && echo "Exiting..." && exit 1

create_distrobox

# distrobox enter $NAME -- chsh -s /bin/zsh
fn_exists post_install && post_install
enter_distrobox
