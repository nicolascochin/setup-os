#!/bin/bash

create_distrobox() {
  distrobox create  \
    --image debian:$VERSION \
    --name $NAME \
    --additional-packages "$PACKAGES_TO_INSTALL"
}

enter_distrobox() {
  distrobox enter $NAME "$@"
}

post_install() {
  setup_nvim_and_tmux
  install_host_exec
}
