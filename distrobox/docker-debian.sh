#!/bin/bash

PACKAGES=(
  systemd # required for docker

  curl            # Docker deps
  ca-certificates # Docker deps

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
  distrobox create --root \
    --image debian:$VERSION \
    --name $NAME \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --init \
    --unshare-all
}

post_install() {
  setup_nvim_and_tmux
  install_docker "debian"
}

enter_distrobox() {
  distrobox enter --root $NAME "$@"
}
