#!/usr/bin/env bash
# Claude Code status line — inspired by Starship prompt
# Layout: [time] directory  git_branch  model  context%

input=$(cat)

# Time (HH:MM)
time_str=$(date +%H:%M)

# Directory — show basename like Starship with truncation
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
if [ "$cwd" = "$project_dir" ]; then
  dir_str=$(basename "$cwd")
else
  # Show relative path from project root
  rel="${cwd#"$project_dir"/}"
  # Truncate like Starship: …/last_component if nested
  parent=$(dirname "$rel")
  base=$(basename "$rel")
  if [ "$parent" = "." ]; then
    dir_str="$base"
  else
    dir_str="…/$base"
  fi
fi

# Git branch
branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  git_str="  $branch"
fi

# Model display name
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Context usage
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  used_int=$(printf "%.0f" "$used")
  ctx_str="  ctx:${used_int}%"
fi

# Assemble: time | directory | git branch | model | context
# Using ANSI colors (will be dimmed by the terminal)
# Yellow for time and directory (matching Starship), gray for secondary info
printf '\033[33m%s\033[0m %s%s\033[90m%s\033[0m%s%s' \
  "$time_str" \
  "$dir_str" \
  "$git_str" \
  "  $model" \
  "$ctx_str" \
  ""
