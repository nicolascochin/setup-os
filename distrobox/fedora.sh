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
  sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
  sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
}
