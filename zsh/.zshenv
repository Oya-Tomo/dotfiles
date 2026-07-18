export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

if [[ ! -o login ]]; then
  source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
