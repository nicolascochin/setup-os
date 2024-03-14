#!/bin/bash 

# Only on Silverblue
! grep -q Silverblue /etc/os-release && echo "This script only runs on Silverblue" && exit 1

# Add VSCode repo
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

PACKAGES_TO_INSTALL=(
  code                     # VSCode
  gh                       # Github CLI
  distrobox                # Distrobox
  libappindicator-gtk3     # Gnome Shell extension for tray icons
  mozilla-https-everywhere # HTTPS enforcement extension for Mozilla Firefox
  mozilla-openh264         # H.264 codec support for Mozilla browsers
  podman-compose
  zsh
  fira-code-fonts          # Font for VSC
)

rpm-ostree install -y ${PACKAGES_TO_INSTALL[@]} 2> /dev/null && reboot
echo "Packages installed."

echo "Change shell for zsh"
chsh --shell /bin/zsh $(whoami) 

## InitramFS
! rpm-ostree status -b | grep -q "Initramfs: regenerate" && (echo "Enable initramfs..." && rpm-ostree initramfs --enable 2> /dev/null && reboot) || echo "Initramfs already enabled"

# Github
gh auth status 2>&1 | grep -q "not logged into"  && echo "Login to Github" && gh auth login
echo "Install Copilot extension for gh" && gh extension install github/gh-copilot
echo "run gh extension upgrade gh-copilot to upgrade"

## Flatpak
declare -A APPS=(
  ["com.protonvpn.www"]="Proton VPN"
  ["com.spotify.Client"]="Spotify"
  ["org.videolan.VLC"]="VLC"
  ["com.brave.Browser"]="Brave Browser"
  ["io.podman_desktop.PodmanDesktop"]="Podman Desktop"
  ["rest.insomnia.Insomnia"]="Insomnia"
  ["com.slack.Slack"]="Slack"
  ["com.discordapp.Discord"]="Discord"
)
for KEY in "${!APPS[@]}"; do 
  NAME="${APPS[$KEY]}"
  ! flatpak list | grep -q $KEY && (echo "Install $NAME" && flatpak install -y $KEY) || echo "$NAME already installed"
done

## Autorun
FLATPAK_DIR=/var/lib/flatpak/exports/share/applications
AUTORUN_DIR=${HOME}/.config/autostart
mkdir -p $AUTORUN_DIR
AUTO_APPS=(
  com.protonvpn.www.desktop
)
for APP in "${AUTO_APPS[@]}"; do 
  ! test -f ${AUTORUN_DIR}/${APP} && echo "Autostart $APP" && ln -s ${FLATPAK_DIR}/${APP} ${AUTORUN_DIR}/${APP}
done

## Fonts
FONT_DIR=${HOME}/.local/share/fonts
mkdir -p $FONT_DIR
declare -A FONTS=(
  ["MesloLGS NF Regular.ttf"]="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  ["MesloLGS NF Bold.ttf"]="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  ["MesloLGS NF Italic.ttf"]="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  ["MesloLGS NF Bold Italic.ttf"]="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)
for FONT_NAME in "${!FONTS[@]}"; do 
  FONT_URL="${FONTS[$FONT_NAME]}"
  echo "install font $FONT_NAME"
  curl -fsSL ${FONT_URL} -o "${FONT_DIR}/${FONT_NAME}"
done

## Gnome Terminal
curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/config/gnome-terminal-profiles.dconf -o /tmp/gnome.dconf && dconf load /org/gnome/terminal/legacy/profiles:/ < /tmp/gnome.dconf

echo
echo "Gnome extensions to install"
echo https://extensions.gnome.org/extension/615/appindicator-support/
echo https://extensions.gnome.org/extension/779/clipboard-indicator/
echo https://extensions.gnome.org/extension/355/status-area-horizontal-spacing/
echo https://extensions.gnome.org/extension/2983/ip-finder/
