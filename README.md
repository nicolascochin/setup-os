# Setup OS

## Silverblue
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-silverblue.sh)
```
## ZSH
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-zsh.sh)
```
## Distrobox
### Create the daily-fedora
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -f fedora -n daily-fedora
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter daily-fedora`

> [!NOTE]  
> Install rbenv build && run rbenv rehash 

### Create the dev
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -f dev -n dev 
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter --no-workdir --clean-path dev`

### Create the docker-debian
```
bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/setup-os/main/setup-distrobox.sh) -f dev-docker -n dev 
```
### Add the shortcut (custom)
Command to use: `gnome-terminal --window -- distrobox enter --no-workdir --clean-path --root  docker-debian`


