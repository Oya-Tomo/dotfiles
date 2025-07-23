# Author: Oya-Tomo
autoload -Uz colors
colors

autoload -U compinit
compinit

setopt print_eight_bit
setopt auto_cd
setopt no_beep
setopt nolistbeep

setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
HISTFILE=~/.zsh_history
ISTSIZE=1000000
SAVEHIST=1000000

setopt correct
setopt extended_glob

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export LS_COLORS="no=00:fi=37:di=32:ln=36:ex=93"

zstyle ':completion:*:default' menu select=1

alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -l --color=auto"
alias lla="ls -l -a --color=auto"
alias l="ls -CF --color=auto"

alias vim="nvim"
alias ide="~/.config/wezterm/alias/ide.sh"

eval "$(starship init zsh)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source "$HOME/.cargo/env"

export PATH="$PATH:$HOME/Packages/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$PATH:$HOME/Packages/android-studio/jbr/bin"
export PATH="$PATH:$HOME/Packages/nvim-linux64/bin"
