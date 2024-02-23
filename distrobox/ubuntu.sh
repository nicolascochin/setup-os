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
  echo "Link flatpak to host" && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
  echo "Link podman to host" && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
  echo "Link firefox to host" && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/firefox

#  echo "Install Plug for Neovim" && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
#  echo "Install Copilot for Neovim" && git clone https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim

#  echo "Install Tmux plugins" && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}