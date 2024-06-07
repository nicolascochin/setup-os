#!/bin/bash

PACKAGES+=(
  systemd         # required for docker
  curl            # Docker deps
  ca-certificates # Docker deps
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
  install_docker
}

enter_distrobox() {
  distrobox enter --root $NAME "$@"
}

install_docker() {
  enter_distrobox -- sudo install -m 0755 -d /etc/apt/keyrings
  enter_distrobox -- sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  enter_distrobox -- sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  enter_distrobox -- sh -c "echo 'deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \$(. /etc/os-release && echo "\$VERSION_CODENAME") stable' | xargs -I % sh -c 'echo %' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
  enter_distrobox -- sudo apt-get update

  # Install Docker
  enter_distrobox -- sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Enable Docker
  enter_distrobox -- sudo systemctl enable --now docker
  enter_distrobox -- sudo usermod -aG docker $USER
}
