#!/bin/bash

PACKAGES=(
  direnv
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
    --image fedora:$VERSION \
    --name $NAME \
    --additional-packages "$PACKAGES_TO_INSTALL"
}

enter_distrobox() {
  distrobox enter $NAME "$@"
}

post_install() {
  setup_nvim_and_tmux
  install_host_exec
}
