common_install() {
  echo "Link flatpak to host"  && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
  echo "Link podman to host"   && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/podman
  echo "Link firefox to host"  && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/firefox
  echo "Link xdg-open to host" && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/xdg-open
  echo "Link code to host" && distrobox enter $1 -- sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/code

  FILE="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim && ! test -f $FILE && echo "Install Plug for Neovim"    && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  DIR=~/.config/nvim/pack/github/start/copilot.vim && ! test -d $DIR && echo "Install Copilot for Neovim" && git clone https://github.com/github/copilot.vim.git $DIR

  DIR=~/.tmux/plugins/tpm && ! test -d $DIR && echo "Install Tmux plugins" && git clone https://github.com/tmux-plugins/tpm $DIR
}
