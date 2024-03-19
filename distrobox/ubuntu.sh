#!/bin/bash

PACKAGES=(
  zsh
  gh
  neovim
  bat
  fzf
  jq
  git
  tmux
  tmate
  figlet
)

create_distrobox() {
  distrobox create  \
    --image ubuntu:$VERSION \
    --name $NAME \
    --additional-packages "$PACKAGES_TO_INSTALL"
}

post_install() {
  COMMON_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/common.sh"
  if curl --output /dev/null --silent --head --fail "$COMMON_SCRIPT_URL"; then
    source <(curl -s "$COMMON_SCRIPT_URL")

    setup_nvim_and_tmux
    install_host_exec
  fi
}
