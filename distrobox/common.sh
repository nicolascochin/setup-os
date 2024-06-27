
setup_nvim_and_tmux() {
  # Plug
  enter_distrobox -- sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  # Copilot 
  enter_distrobox -- sh -c 'git clone -q https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim'
  # Tmux
  enter_distrobox -- sh -c 'git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'
}

install_host_exec() {
  echo "Link flatpak to host"  && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
  echo "Link podman to host"   && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
  echo "Link firefox to host"  && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/firefox
  echo "Link xdg-open to host" && enter_distrobox -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open
}

PACKAGES=(
  direnv
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

DEV_PACKAGES=(
  systemd
  openssh-server
  build-essential 
  libz-dev # rbenv
  libpq-dev # ruby
  libffi-dev # ruby 3
  libyaml-dev # ruby 3
  rbenv
  chromium # visual tests
)
