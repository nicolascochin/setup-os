#!/bin/bash

PACKAGES+=$DEV_PACKAGES
PACKAGES+=(
  curl            # Docker deps
  ca-certificates # Docker deps
)

create_distrobox() {
  distrobox create --root \
    --image debian:$VERSION \
    --name $NAME \
    --hostname $NAME \
    --home ${HOME}/distroboxes/${NAME} \
    --volume ${HOME}/Workspace:${HOME}/distroboxes/${NAME}/Workspace:ro \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --init \
    --init-hooks "sudo sed -i \"s/^#Port 22/Port $PORT/\" /etc/ssh/sshd_config && sudo systemctl enable ssh" \
    --unshare-all
}

post_install() {
  echo "Finish installation"
  enter_distrobox -- echo
  
  echo "Setup ZSH"
  enter_distrobox -- sh -c "unset ZSH && unset NVM_DIR && unset XDG_CONFIG_HOME && curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh | bash"

  echo "Setup vim, copilot and tmux"
  setup_nvim_and_tmux
  
  echo "Install Docker"
  install_docker
  
  echo "Config SSH"
  cat <<EOF >> ~/.ssh/config
Host $NAME
  User nico
  Port $PORT
  HostName localhost
EOF

  echo "Enter distrobox and setup config-files project"
}

enter_distrobox() {
  distrobox enter --root --no-workdir --clean-path $NAME "$@"
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
