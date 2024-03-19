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
    --image ubuntu:$VERSION \
    --name $NAME \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --init \
    --unshare-all
}

post_install() {
  COMMON_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/common.sh"
  # if curl --output /dev/null --silent --head --fail "$COMMON_SCRIPT_URL"; then
  #   source <(curl -s "$COMMON_SCRIPT_URL")

  #   setup_nvim_and_tmux
  # fi
  setup_docker
}

enter_distrobox() {
  distrobox enter --root $NAME "$@"
}

setup_docker() {
  enter_distrobox -- \
    sudo install -m 0755 -d /etc/apt/keyrings \
    && sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && sudo chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "Add the repository to Apt sources..." \
    && echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && sudo apt-get update \
    && echo "Install Docker..." \
    && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && echo "Enable Docker..." \
    && sudo systemctl enable --now docker \
    && sudo usermod -aG docker $USER
}
