# Setup OS

## Silverblue
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-silverblue.sh)
```

## Distrobox
### Create the daily-fedora
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -i fedora -n daily-fedora
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter daily-fedora`

### Create the daily-ubuntu
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -i ubuntu -n daily-ubuntu
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter daily-ubuntu`

### Create the docker-debian
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -i docker-debian -n docker-debian
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter --root docker-debian`


## ZSH
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh)
```
