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

zstyle ':completion:*:default' menu select=1

alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -l --color=auto"
alias lla="ls -l -a --color=auto"
alias l="ls -CF --color=auto"

ok="%F{35} %f"
ng="%F{196} %f"
os=""

PROMPT="%F{237}%F{32}%K{237}%n%F{242} $os %F{32}%m%F{237}%K{240} %F{252}%~%k%F{240} %f"
RPROMPT="%(?.$ok.$ng)"
