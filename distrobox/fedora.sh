#!/bin/bash

create_distrobox() {
  distrobox create  \
    --image fedora:$VERSION \
    --name $NAME \
    --additional-packages "$PACKAGES_TO_INSTALL"
}

enter_distrobox() {
  distrobox enter $NAME "$@"
}

post_install() {
  echo "Finish installation"
  enter_distrobox -- echo
}
