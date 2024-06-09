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

install_vsc() {
  echo "Install VSC"  
  enter_distrobox -- sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  enter_distrobox -- sudo dnf install -y code
}

post_install() {
  install_host_exec
  install_vsc
}
