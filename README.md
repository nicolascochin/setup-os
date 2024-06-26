# Setup OS

## Silverblue
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-silverblue.sh)
```

## Distrobox
### Create the daily-fedora
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -f fedora -n daily-fedora
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter daily-fedora`

### Create the dev
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -f dev -n dev -p 2222
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter dev`

### Create the docker-debian
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -f dev-docker -n dev -p 2222
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter --root docker-debian`


## ZSH
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh)
```
