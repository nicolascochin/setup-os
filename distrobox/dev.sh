#!/bin/bash

PACKAGES+=(${DEV_PACKAGES[@]})

create_distrobox() {
  args=()
  args+=("--image debian:$VERSION")
  args+=("--name $NAME")
  args+=("--hostname $NAME")
  args+=("--home ${HOME}/distroboxes/${NAME}")
  args+=("--additional-packages $PACKAGES_TO_INSTALL")
  is_ssh_setup && args+=( "--init --init-hooks \"sudo sed -i \\\"s/^#Port 22/Port $PORT/\" /etc/ssh/sshd_config && sudo systemctl enable ssh\\\"" ) 

  echo "$args"
  echo "distrobox create  $(echo "$args")"
  ! do_we_continue && echo "Exiting..." && exit 1
  distrobox create  $(echo "$args")  
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
