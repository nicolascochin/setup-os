#!/bin/bash

PACKAGES=(
  systemd # required for docker

  docker-compose
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
    --image fedora:$VERSION \
    --name $NAME \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --init \
    --unshare-all
}

post_install() {
  setup_nvim_and_tmux
  install_docker
}

enter_distrobox() {
  distrobox enter --root $NAME "$@"
}


install_docker() {
  enter_distrobox -- sudo dnf -y install dnf-plugins-core
  enter_distrobox -- sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

  enter_distrobox -- sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  enter_distrobox -- sudo systemctl start docker
  enter_distrobox -- sudo systemctl enable docker
  enter_distrobox -- sudo usermod -aG docker $USER
}
