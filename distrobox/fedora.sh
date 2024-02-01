#!/bin/bash 

PACKAGES=(
  zsh 
  gh 
  neovim 
  bat 
  fzf 
  jq 
  git 
  tmux 
  tmate
  figlet
)

# $1: name of the distrobox
custom_install() {
  ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
  ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
}
