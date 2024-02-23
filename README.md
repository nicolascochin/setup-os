# Setup OS

## Silverblue
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-silverblue.sh)
```

## Distrobox
### Create the daily-fedora
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) fedora daily-fedora
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter daily-fedora`

### Create the daily-ubuntu
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) ubuntu daily-ubuntu
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter daily-ubuntu`


## ZSH
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh)
```
