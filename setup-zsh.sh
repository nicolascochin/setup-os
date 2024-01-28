#!/usr/bin/env bash

# $1 == name
# $2 == test
function check_not_installed {
  if ${2} > /dev/null
  then
    echo "$(print_bold "$1") is already installed."
  else
    echo "$(print_bold "$1") is not installed. Installing..."
    return
  fi
  false
}

# $1 == text
function print_light_cyan {
  echo -n "\e[96m$1"
}

# $1 == text
function print_bold {
  echo -e "\e[1m$(print_light_cyan "$1")\e[0m"
}

#############
# OH MY ZSH #
#############
check_not_installed oh-my-zsh "test -d ${HOME}/.oh-my-zsh" && (
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
)

###################
# POWER LEVEL 10K #
###################
POWERLEVEL_10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
check_not_installed "oh-my-zsh theme powerlevel10k" "test -d ${POWERLEVEL_10K_DIR}" && (
  git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git ${POWERLEVEL_10K_DIR}
)

###################
# AUTOSUGGESTIONS #
###################
AUTOSUGGEST_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
check_not_installed "oh-my-zsh plugin autosuggest" "test -d ${AUTOSUGGEST_DIR}" && (
  git clone -q https://github.com/zsh-users/zsh-autosuggestions ${AUTOSUGGEST_DIR}
)

###############
# HIGHLIGHTED #
###############
HIGHLIGHTED_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
DRACULA_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/dracula
check_not_installed "oh-my-zsh plugin zsh-syntax-highlighting" "test -d ${HIGHLIGHTED_DIR}" && (
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ${HIGHLIGHTED_DIR}
  git clone -q https://github.com/dracula/zsh-syntax-highlighting.git ${DRACULA_DIR}
)

############################
# FAST SYNTAX HIGHLIGHTING #
############################
FAST_SYNTAXT_HIGHLIGHTING_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H
check_not_installed "oh-my-zsh plugin fast syntaxt hightlighting" "test -d ${FAST_SYNTAXT_HIGHLIGHTING_DIR}" && (
  git clone -q https://github.com/zsh-users/zsh-autosuggestions ${FAST_SYNTAXT_HIGHLIGHTING_DIR}
  git clone https://github.com/z-shell/F-Sy-H.git 
)


##########
# ANYENV #
##########
ANYENV_DIR=${HOME}/.anyenv
check_not_installed anyenv "test -d ${ANYENV_DIR}" && (
  git clone -q https://github.com/anyenv/anyenv ${ANYENV_DIR}
  ${ANYENV_DIR}/bin/anyenv install --force-init
)

#######
# FIG #
#######
FIG_DIR=${HOME}/.fig
check_not_installed "Forgit (FIG)" "test -d ${FIG_DIR}" && (
  git clone -q https://github.com/wfxr/forgit.git ${FIG_DIR}
)
