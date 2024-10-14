#!/bin/bash

PACKAGES+=(${DEV_PACKAGES[@]})
PACKAGES+=(
  curl            # Docker deps
  ca-certificates # Docker deps
  firefox-esr     # stable browser 
)

create_distrobox() {
  create_args=()
  create_args+=("--root")
  create_args+=("--image debian:$VERSION")
  create_args+=("--name $NAME")
  create_args+=("--hostname $NAME")
  create_args+=("--home ${HOME}/distroboxes/${NAME}")
  create_args+=("--additional-packages \"$PACKAGES_TO_INSTALL\"")
  create_args+=("--volume ${HOME}/Workspace:${HOME}/distroboxes/${NAME}/Workspace:rw")
  create_args+=("--volume ${HOME}/.ssh:${HOME}/distroboxes/${NAME}/.ssh")
  create_args+=("--init")
  is_ssh_setup && create_args+=( "--init-hooks \"sudo sed -i \\\"s/^#Port 22/Port 22/\\\" /etc/ssh/sshd_config && sudo systemctl enable ssh\"" ) 
  create_args+=("--unshare-all")

  echo "distrobox create $(echo "${create_args[@]}")" | bash
}

pre_install() {
  ! do_we_continue "Setup SSh" && SKIP_SSH=true
}

post_install() {
  echo "Finish installation"
  enter_distrobox -- echo
  echo
  echo "Setup ZSH"
  enter_distrobox -- sh -c "unset ZSH && unset NVM_DIR && unset XDG_CONFIG_HOME && curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh | bash"
  echo
  install_nvm
  setup_rbenv
  echo 
  echo "Install Docker" && install_docker
  echo
  is_ssh_setup && (
    echo "Config SSH"
    cat <<EOF >> ~/.ssh/config
Host $NAME
  User $(whoami)
  Port 22
  HostName ${NAME}.local  
EOF
)
  echo
  install_gh_and_ssh
  echo  
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
