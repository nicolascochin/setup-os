#!/bin/bash

# $1: image to use
# $2: name of the distrobox

IMAGE=$(test -z $1 && echo "fedora" || echo $1)

declare -A PACKAGES=(
  ["fedora"]="zsh gh neovim bat fzf jq git tmux tmate"
)

PACKAGES_TO_INSTALL=$(! [ "${PACKAGES[$IMAGE]+foo}"  ] && echo "" || echo "${PACKAGES[$IMAGE]}")
#PACKAGES_TO_INSTALL=$(! [ "${PACKAGES[$IMAGE]+foo}"  ] && echo "Image '$IMAGE' is unknown. Exiting..." && exit 1)

echo "Installing distrobox with image: $IMAGE"
echo "Packages: >${PACKAGES_TO_INSTALL}<"
exit
CUSTOM_HOME=$HOME/Distroboxes/$IMAGE

distrobox create  \
  --image $IMAGE \
  --additional-packages "$PACKAGES_TO_INSTALL"

#  --home $CUSTOM_HOME \
#ln -s $HOME $CUSTOM_HOME/bip

distrobox enter $IMAGE -- chsh -s /bin/zsh
distrobox enter $IMAGE
