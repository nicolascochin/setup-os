#!/bin/bash

PACKAGES+=(${DEV_PACKAGES[@]})
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
    --volume ${HOME}/Workspace:${HOME}/distroboxes/${NAME}/Workspace:rw \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --init \
    --unshare-all
}

post_install() {
  echo "Finish installation"
  enter_distrobox -- echo
  echo
  echo "Setup ZSH"
  enter_distrobox -- sh -c "unset ZSH && unset NVM_DIR && unset XDG_CONFIG_HOME && curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh | bash"
  echo
  install_nvm
  echo
  echo "Install VSC" && install_vscode
  echo 
  echo "Install Docker" && install_docker
  echo
  echo "Login to Github" && enter_distrobox -- gh auth login
  echo  
  echo "Enter distrobox and setup config-files project"
}

enter_distrobox() {
  distrobox enter --root --no-workdir --clean-path $NAME "$@"
}

install_vscode() {
  enter_distrobox -- sudo apt-get install wget gpg
  enter_distrobox -- wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  enter_distrobox -- sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  enter_distrobox -- echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  enter_distrobox -- rm -f packages.microsoft.gpg
  enter_distrobox -- sudo apt install apt-transport-https
  enter_distrobox -- sudo apt update
  enter_distrobox -- sudo apt install code
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
