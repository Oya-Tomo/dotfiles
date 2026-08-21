#!/usr/bin/env bash
# Claude Code status line — inspired by Starship prompt
# Layout: time  directory  git_branch  model  effort  context_usage
set -uo pipefail

input=$(cat)

# One field per line — tabs would collapse empty fields on `read`.
mapfile -t fields < <(
  jq -r '[
    (.workspace.current_dir // ""),
    (.model.display_name // .model.id // ""),
    (.effort.level // ""),
    ((.context_window.current_usage // {})
      | (.input_tokens // 0)
        + (.output_tokens // 0)
        + (.cache_creation_input_tokens // 0)
        + (.cache_read_input_tokens // 0)),
    (.context_window.context_window_size // 0),
    (.context_window.used_percentage // 0)
  ] | .[] | tostring' <<<"$input" 2>/dev/null
)
cwd=${fields[0]:-}
model=${fields[1]:-}
effort=${fields[2]:-}
ctx_used=${fields[3]:-0}
ctx_size=${fields[4]:-0}
ctx_pct=${fields[5]:-0}

# Time (HH:MM)
time_str=$(date +%H:%M)

# Directory — ~ for $HOME, truncated to the last 3 components like Starship
[ -z "$cwd" ] && cwd=$PWD
dir_str=${cwd/#"$HOME"/'~'}
IFS='/' read -ra segs <<<"$dir_str"
if [ "${#segs[@]}" -gt 3 ]; then
  dir_str="…/${segs[-3]}/${segs[-2]}/${segs[-1]}"
fi

# Git branch, or short SHA when detached. Empty outside a repo.
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --quiet --short HEAD 2>/dev/null) ||
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

# Context usage — used/limit in K tokens, coloured by how full the window is
ctx_str=""
if [ "${ctx_size:-0}" -gt 0 ] 2>/dev/null; then
  pct=$(printf '%.0f' "$ctx_pct")
  # green < 50%, yellow < 80%, red above
  if [ "$pct" -lt 50 ]; then
    ctx_color='0;32'
  elif [ "$pct" -lt 80 ]; then
    ctx_color='0;33'
  else
    ctx_color='1;31'
  fi
  ctx_str=$(printf '\033[%sm%d/%dKtk %d%%\033[0m' \
    "$ctx_color" "$(((ctx_used + 500) / 1000))" "$(((ctx_size + 500) / 1000))" "$pct")
fi

printf '\033[90m%s\033[0m \033[1;34m%s\033[0m' "$time_str" "$dir_str"
[ -n "$branch" ] && printf ' \033[0;35m%s\033[0m' "$branch"
[ -n "$model" ] && printf ' \033[0;36m%s\033[0m' "$model"
[ -n "$effort" ] && printf ' \033[2;36m%s\033[0m' "$effort"
[ -n "$ctx_str" ] && printf ' %s' "$ctx_str"
