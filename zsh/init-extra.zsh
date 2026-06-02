# Author: Oya-Tomo
[ -f ~/.secrets ] && source ~/.secrets

autoload -Uz colors
colors

autoload -U compinit
compinit

setopt print_eight_bit
setopt auto_cd
setopt no_beep
setopt nolistbeep
setopt correct
setopt extended_glob

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export LS_COLORS="no=00:fi=37:di=34:ln=36:ex=32:pi=33:so=35:bd=33:cd=33:or=31:mi=31:ow=34;42"

zstyle ':completion:*:default' menu select=1

# Terminal IDE layout
if [ "$TERM_PROGRAM" = "ghostty" ]; then
  ide() { echo "Ghostty does not support IDE layout from script." }
elif [ "$TERM_PROGRAM" = "WezTerm" ]; then
  alias ide="zsh ~/.config/wezterm/alias/ide.sh"
fi

# Tailscale
alias tsen-on="sudo tailscale up --exit-node=${TS_EXIT_NODE}"
alias tsen-off="sudo tailscale up --exit-node="

# Sync lazy.nvim lockfile to dotfiles repo
alias nvim-lock-sync="cp ~/.local/share/nvim/lazy-lock.json ~/dotfiles/nvim/lazy-lock.json"

# Claude shortcuts
alias claude-local="ANTHROPIC_BASE_URL=http://${CLAUDE_LOCAL_HOST}:${CLAUDE_LOCAL_PORT} ANTHROPIC_API_KEY='llama.cpp' claude --model ${CLAUDE_LOCAL_MODEL}"
alias claude-glm="ANTHROPIC_BASE_URL='https://api.z.ai/api/anthropic' \
  ANTHROPIC_AUTH_TOKEN=${ZAI_TOKEN} \
  API_TIMEOUT_MS=3000000 \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='glm-4.5-air' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='glm-5.1' \
  ANTHROPIC_DEFAULT_OPUS_MODEL='glm-5.1' \
  claude"
