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
    --additional-flags "-p 2222:22" 
}

enter_distrobox() {
  distrobox enter $NAME "$@"
}

post_install() {
}
