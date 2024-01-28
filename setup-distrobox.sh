#!/bin/bash

# $1: image to use
# $2: name of the distrobox

IMAGE=$(test -z $1 && echo "fedora" || echo $1)
NAME=$(test -z $2 && echo "$IMAGE" || echo $2)
VERSION=latest
DISTRO_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/$IMAGE.sh"

## Functions
fn_exists() { declare -F "$1" > /dev/null; }

# $1 == title
do_we_continue() {
  while
    echo $1
    echo -n "Do you want to continue? (y|n)"
    read RESPONSE
    ! echo ${RESPONSE} | egrep -q "^y|n$"
  do true; done
  if [[ ${RESPONSE} == "y" ]]; then
    return
  fi
  echo "skipping"
  false
}


## Script
if curl --output /dev/null --silent --head --fail "$DISTRO_SCRIPT_URL"; then
  echo "Fetching custom distrobox file"
  source <(curl -s "$DISTRO_SCRIPT_URL")
fi

PACKAGES_TO_INSTALL=${PACKAGES[@]:-""}

echo "Installing distrobox with name: $NAME"
echo "Installing distrobox with image: $IMAGE"
echo "Packages: >${PACKAGES_TO_INSTALL}<"
! do_we_continue && echo "Exiting..." && exit 1

distrobox create  \
  --image $IMAGE:$VERSION \
  --name $NAME \
  --additional-packages "$PACKAGES_TO_INSTALL"

distrobox enter $IMAGE -- chsh -s /bin/zsh
fn_exists custom_install && custom_install "$NAME"
distrobox enter $IMAGE
