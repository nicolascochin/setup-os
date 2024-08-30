#!/bin/bash

PACKAGES+=(${DEV_PACKAGES[@]})

create_distrobox() {
  distrobox create  \
    --image debian:$VERSION \
    --name $NAME \
    --hostname $NAME \
    --home ${HOME}/distroboxes/${NAME} \
    --volume ${HOME}/Workspace:${HOME}/distroboxes/${NAME}/Workspace:rw \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --init \
    --init-hooks "sudo sed -i \"s/^#Port 22/Port $PORT/\" /etc/ssh/sshd_config && sudo systemctl enable ssh" 
}

enter_distrobox() {
  distrobox enter --no-workdir --clean-path $NAME "$@"
}

post_install() {
  echo "Finish installation"
  enter_distrobox -- echo
  echo
  echo "Setup ZSH"
  enter_distrobox -- sh -c "unset ZSH && unset NVM_DIR && unset XDG_CONFIG_HOME && curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh | bash"
  echo 
  install_nvm
  echo "Link podman to host"   && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
  echo
  echo "Config SSH"
  cat <<EOF >> ~/.ssh/config
Host $NAME
  User nico
  Port $PORT
  HostName localhost
EOF
  echo
  install_gh_and_ssh
  echo
  echo "Enter distrobox and setup config-files project"
}
