typeset -U path cdpath fpath manpath
for profile in ${(z)NIX_PROFILES}; do
  fpath+=(
    $profile/share/zsh/site-functions
    $profile/share/zsh/$ZSH_VERSION/functions
    $profile/share/zsh/vendor-completions
  )
done

# History
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.zsh_history"

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt NO_APPEND_HISTORY
setopt NO_EXTENDED_HISTORY

# Aliases
alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias ll='ls -l --color=auto'
alias lla='ls -l -a --color=auto'
alias l='ls -CF --color=auto'
alias vim='nvim'
alias hms='nix run home-manager -- switch --flake ~/dotfiles'

# Secrets
[[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"

# Shell behavior
autoload -Uz colors
colors

autoload -Uz compinit
zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$zsh_cache_dir"
compinit -d "$zsh_cache_dir/zcompdump"
unset zsh_cache_dir

setopt PRINT_EIGHT_BIT
setopt AUTO_CD
setopt NO_BEEP
setopt NO_LIST_BEEP
setopt CORRECT
setopt EXTENDED_GLOB

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export LS_COLORS='no=00:fi=37:di=34:ln=36:ex=32:pi=33:so=35:bd=33:cd=33:or=31:mi=31:ow=34;42'

zstyle ':completion:*:default' menu select=1

# Terminal integration
if [[ -r "$HOME/.nix-profile/etc/profile.d/wezterm.sh" ]]; then
  source "$HOME/.nix-profile/etc/profile.d/wezterm.sh"
fi

if [[ "$TERM_PROGRAM" == ghostty ]]; then
  ide() { echo 'Ghostty does not support IDE layout from script.' }
elif [[ "$TERM_PROGRAM" == WezTerm ]]; then
  alias ide='zsh ~/.config/wezterm/alias/ide.sh'
fi

# Prompt and directory hooks
if [[ $TERM != dumb ]] && command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Lazygit wrapper that follows directory changes made within lazygit.
function lg() {
  export LAZYGIT_NEW_DIR_FILE="$HOME/.lazygit/newdir"
  command lazygit "$@"
  if [[ -f "$LAZYGIT_NEW_DIR_FILE" ]]; then
    cd "$(<"$LAZYGIT_NEW_DIR_FILE")"
    rm -f "$LAZYGIT_NEW_DIR_FILE"
  fi
}

# Tailscale
alias tsen-on='sudo tailscale up --exit-node=${TS_EXIT_NODE}'
alias tsen-off='sudo tailscale up --exit-node='

# Sync lazy.nvim lockfile to the dotfiles repository.
alias nvim-lock-sync='cp ~/.local/share/nvim/lazy-lock.json ~/dotfiles/nvim/lazy-lock.json'

# Claude shortcuts
alias claude-local="ANTHROPIC_BASE_URL=http://${CLAUDE_LOCAL_HOST}:${CLAUDE_LOCAL_PORT} ANTHROPIC_API_KEY='llama.cpp' claude --model ${CLAUDE_LOCAL_MODEL}"
alias claude-glm="ANTHROPIC_BASE_URL='https://api.z.ai/api/anthropic' \
  ANTHROPIC_AUTH_TOKEN=${ZAI_TOKEN} \
  API_TIMEOUT_MS=3000000 \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='glm-4.5-air' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='glm-5.1' \
  ANTHROPIC_DEFAULT_OPUS_MODEL='glm-5.2' \
  claude"
