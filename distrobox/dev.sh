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
    --init-hooks init_hook_ssh 
}

init_hook_ssh() {
  if is_ssh_setup; then 
    echo "sudo sed -i \"s/^#Port 22/Port $PORT/\" /etc/ssh/sshd_config && sudo systemctl enable ssh"
  else
    echo "echo 'skipping ssh'"
  fi
}

enter_distrobox() {
  distrobox enter --no-workdir --clean-path $NAME "$@"
}

pre_install() {
  if do_we_continue "Setup SSh"; then 
    echo "Setup SSH"
    echo "Current used ports are: "
    sed -n -e '/^Host /{h;d;}' -e '/^\ *Port /{H;x;s/\n/ /p;}' ~/.ssh/config
    while
      read -p "Please enter a port number: " PORT
      ! echo "$PORT" | grep -qE '^[0-9]+$'
    do true; done
  else
    SKIP_SSH=true
  fi
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
  echo "Link podman to host"   && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
  echo
  is_ssh_setup && (
    echo "Config SSH"
    cat <<EOF >> ~/.ssh/config
Host $NAME
  User nico
  Port $PORT
  HostName localhost
EOF
)
  echo
  install_gh_and_ssh
  echo
  echo "Enter distrobox and setup config-files project"
}
