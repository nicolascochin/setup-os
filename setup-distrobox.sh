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
##

# Get args
while getopts i:v:n: flag
do
    case "${flag}" in
        i) INPUT_IMAGE=${OPTARG};;
        v) INPUT_VERSION=${OPTARG};;
        n) INPUT_NAME=${OPTARG};;
    esac
done

# Ask for user input if args were not given
IMAGE=${INPUT_IMAGE:-$(read_input "Enter an image: ")}
VERSION=${INPUT_VERSION:-latest}
NAME=${INPUT_NAME:-$(read_input "Enter a container name: ")}

DISTRO_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/$IMAGE.sh"


## Script
echo "Fetching recipe for distrobox $IMAGE"
if curl --output /dev/null --silent --head --fail "$DISTRO_SCRIPT_URL"; then
  source <(curl -s "$DISTRO_SCRIPT_URL")
else
  echo "$DISTRO_SCRIPT_URL is not found. Don't knwo how to build distrobox. Stop!"
  exit 1
fi
PACKAGES_TO_INSTALL=${PACKAGES[@]:-""}

echo "Installing distrobox with name: $NAME"
echo "Packages: >${PACKAGES_TO_INSTALL}<"
! do_we_continue && echo "Exiting..." && exit 1

create_distrobox
exit
# distrobox enter $NAME -- chsh -s /bin/zsh
fn_exists custom_install && custom_install
distrobox enter $NAME
