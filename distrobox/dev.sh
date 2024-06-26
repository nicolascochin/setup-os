#!/bin/bash

PACKAGES+=(
  systemd
  openssh-serverho
  build-essential 
  libz-dev # rbenv
  libpq-dev # ruby
  rbenv
  chromium # visual tests
)

create_distrobox() {
  distrobox create  \
    --image debian:$VERSION \
    --name $NAME \
    --hostname $NAME \
    --home ${HOME}/distroboxes/${NAME} \
    --volume ${HOME}/Workspace:/home/$(whoami)/Workspace:ro \
    --init \
    --init-hooks "sudo sed -i \"s/^#Port 22/Port $PORT/\" /etc/ssh/sshd_config && sudo systemctl enable ssh" \
    --additional-packages "$PACKAGES_TO_INSTALL" \
    --verbose
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
