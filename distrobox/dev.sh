#!/bin/bash

PACKAGES+=(
  systemd
  openssh-server
)

create_distrobox() {
  distrobox create  \
    --image debian:$VERSION \
    --name $NAME \
    --hostname $NAME \
    --unshare-all \
    --init \
    --init-hooks "sudo systemctl enable ssh" \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --additional-flags "-p $PORT:22" 
}

enter_distrobox() {
  distrobox enter $NAME "$@"
}

post_install() {
  echo "Finish installation"
  enter_distrobox -- echo
  
  echo "Config SSH"
  echo <<EOF >> ~/.ssh/config
Host $NAME
  User nico
  Port $PORT
  HostName localhost
EOF
 
  echo "Set password"
  enter_distrobox -- passwd

  echo "Copy SSH ID"
  ssh-copy-id $NAME
}
