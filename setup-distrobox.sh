#!/bin/bash

# $1: image to use
# $2: name of the distrobox

IMAGE=$(test -z $1 && echo "fedora" || echo $1)
NAME=$(test -z $2 && echo "$IMAGE" || echo $2)
DISTRO_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/$IMAGE.sh"

fn_exists() { declare -F "$1" > /dev/null; }

if curl --output /dev/null --silent --head --fail "$DISTRO_SCRIPT_URL"; then
  echo "Fetching custom distrobox file"
  source <(curl -s "$DISTRO_SCRIPT_URL")
fi

PACKAGES_TO_INSTALL=${PACKAGES[@]:-""}

echo "Installing distrobox with name: $NAME"
echo "Installing distrobox with image: $IMAGE"
echo "Packages: >${PACKAGES_TO_INSTALL}<"

distrobox create  \
  --image $IMAGE \
  --additional-packages "$PACKAGES_TO_INSTALL"

distrobox enter $IMAGE -- chsh -s /bin/zsh
fn_exists custom_install && custom_install "$NAME"
distrobox enter $IMAGE
