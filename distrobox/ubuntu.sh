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
  COMMON_SCRIPT_URL="https://raw.githubusercontent.com/nicolascochin/setup-os/main/distrobox/common.sh"
  if curl --output /dev/null --silent --head --fail "$COMMON_SCRIPT_URL"; then
    echo "Fetching common distrobox file"
    source <(curl -s "$COMMON_SCRIPT_URL")
    common_install "$1"
  fi
}
