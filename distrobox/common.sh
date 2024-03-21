
setup_nvim_and_tmux() {
  FILE="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim && ! test -f $FILE && echo "Install Plug for Neovim"    && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  DIR=~/.config/nvim/pack/github/start/copilot.vim && ! test -d $DIR && echo "Install Copilot for Neovim" && git clone https://github.com/github/copilot.vim.git $DIR

  DIR=~/.tmux/plugins/tpm && ! test -d $DIR && echo "Install Tmux plugins" && git clone https://github.com/tmux-plugins/tpm $DIR
}

install_host_exec() {
  echo "Link flatpak to host"  && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
  echo "Link podman to host"   && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
  echo "Link firefox to host"  && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/firefox
  echo "Link xdg-open to host" && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open
  echo "Link code to host" && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/code
}


# $1 distro: ubuntu or debian
install_docker() {
  enter_distrobox -- sudo install -m 0755 -d /etc/apt/keyrings
  enter_distrobox -- sudo curl -fsSL https://download.docker.com/linux/$1/gpg -o /etc/apt/keyrings/docker.asc
  enter_distrobox -- sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  enter_distrobox -- sh -c "echo 'deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$1 \$(. /etc/os-release && echo "\$VERSION_CODENAME") stable' | xargs -I % sh -c 'echo %' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
  enter_distrobox -- sudo apt-get update

  # Install Docker
  enter_distrobox -- sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Enable Docker
  enter_distrobox -- sudo systemctl enable --now docker
  enter_distrobox -- sudo usermod -aG docker $USER
}
