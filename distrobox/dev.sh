#!/bin/bash

PACKAGES+=(
  systemd
  openssh-server
  build-essential 
  libz-dev # rbenv
  libpq-dev # ruby
  rbenv
)

create_distrobox() {
  distrobox create  \
    --image debian:$VERSION \
    --name $NAME \
    --hostname $NAME \
    --init \
    --init-hooks "sudo sed -i \"s/^#Port 22/Port $PORT/\" /etc/ssh/sshd_config && sudo systemctl enable ssh" \
    --additional-packages "$PACKAGES_TO_INSTALL" 
}

enter_distrobox() {
  distrobox enter $NAME "$@"
}

post_install() {
  echo "Finish installation"
  enter_distrobox -- echo
  
  echo "Config SSH"
  cat <<EOF >> ~/.ssh/config
Host $NAME
  User nico
  Port $PORT
  HostName localhost
EOF
}