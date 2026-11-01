#!/usr/bin/env bash
# Claude subscription usage for the shell prompt — remaining 5-hour and 7-day quota.
# Prints from a cache and refreshes it in the background, so the prompt never waits
# on the network. The endpoint is the undocumented one behind `/usage`; anything
# missing or malformed prints nothing instead of failing the prompt.
set -uo pipefail

creds="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/claude-usage"
cache="$cache_dir/usage.json"
attempt="$cache_dir/last-attempt"
refresh_interval=60 # seconds between fetch attempts
stale_after=600     # seconds after the last successful fetch to mark the output stale

# The access token is refreshed only by Claude Code itself; rotating it here would
# invalidate the refresh token Claude Code holds. An expired token just fails the
# fetch and leaves the cache stale until the next Claude Code session.
refresh() {
  local token tmp
  token=$(jq -er '.claudeAiOauth.accessToken' "$creds") || return
  tmp=$(mktemp "$cache.XXXXXX") || return
  if curl -fsS -m 10 -o "$tmp" \
    -H "Authorization: Bearer $token" \
    -H 'anthropic-beta: oauth-2025-04-20' \
    https://api.anthropic.com/api/oauth/usage &&
    jq -e 'type == "object"' "$tmp" >/dev/null; then
    mv -f "$tmp" "$cache"
  else
    rm -f "$tmp"
  fi
}

mtime() { stat -c %Y "$1" 2>/dev/null || echo 0; }

[ -r "$creds" ] || exit 0
mkdir -p "$cache_dir" || exit 0

now=$(date +%s)
if [ $((now - $(mtime "$attempt"))) -ge "$refresh_interval" ]; then
  touch "$attempt"
  refresh </dev/null >/dev/null 2>&1 &
fi

[ -f "$cache" ] || exit 0
stale=$([ $((now - $(mtime "$cache"))) -ge "$stale_after" ] && echo true || echo false)

# Windows whose reset time has passed are dropped: their cached figure no longer holds.
jq -r --argjson now "$now" --argjson stale "$stale" '
  def epoch: try (sub("\\.[0-9]+"; "") | sub("\\+00:00$"; "Z") | fromdate) catch 0;
  [ (["5h", .five_hour], ["7d", .seven_day])
    | select(.[1].utilization? != null and (.[1].resets_at | epoch) > $now)
    | "\(.[0]) \(100 - .[1].utilization | floor)%" ]
  | select(length > 0)
  | join(" ") + (if $stale then "?" else "" end)
' "$cache" 2>/dev/null
