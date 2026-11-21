#!/usr/bin/env bash
# Monitoring ticks for impl-with-monitoring.
#
#   tick.sh init  <state-dir> <repo> <rules.yml> <progress-log>
#   tick.sh tick  <state-dir> [--quiet SECONDS] [--max-lines N]
#   tick.sh final <state-dir>
#
# A tick prints a compact digest: change stats, ast-grep rule hits added or
# removed since the previous tick, and new progress log lines. It shows the
# structural diff only for files that settled (unmodified for --quiet seconds,
# default 60) and changed since they were last shown, starting from the version
# last shown, so no line is read twice. All state lives in <state-dir>.

set -euo pipefail

die() { echo "tick.sh: $*" >&2; exit 2; }
(( $# >= 2 )) || die "usage: tick.sh init|tick|final <state-dir> ..."
cmd=$1 state=$2
shift 2

# Write the worktree, including untracked files, as a tree without touching the real index.
snapshot() {
  local idx git_idx status=0
  idx=$(mktemp -u)
  git_idx=$(git rev-parse --git-path index)
  [[ -f $git_idx ]] && cp "$git_idx" "$idx"
  { GIT_INDEX_FILE=$idx git add -A >&2 && GIT_INDEX_FILE=$idx git write-tree; } || status=$?
  rm -f "$idx"
  return "$status"
}

# One line per rule hit as "rule<TAB>file<TAB>first matched line", sorted, so
# hits can be compared across ticks independently of line numbers.
scan_hits() {
  local err
  err=$(mktemp)
  ast-grep scan -r "$rules" --json=stream . 2>"$err" \
    | jq -r '[.ruleId, .file, (.lines | split("\n")[0] | gsub("^\\s+|\\s+$"; ""))] | @tsv' \
    | LC_ALL=C sort || true
  grep -v -e 'error(s) found in code' -e 'Scan succeeded' -e '^\s*$' "$err" >&2 || true
  rm -f "$err"
}

print_hit_delta() {  # $1 old hits file, $2 new hits file
  local added removed
  added=$(LC_ALL=C comm -13 "$1" "$2")
  removed=$(LC_ALL=C comm -23 "$1" "$2")
  if [[ -z $added && -z $removed ]]; then
    echo "(no change)"
    return
  fi
  [[ -n $added ]] && sed 's/^/+ /' <<<"$added"
  [[ -n $removed ]] && sed 's/^/- /' <<<"$removed"
  return 0
}

structural_diff() {  # $1 from tree, $2 to tree, rest: paths
  local from=$1 to=$2
  shift 2
  if command -v difft >/dev/null; then
    GIT_EXTERNAL_DIFF=difft DFT_DISPLAY=inline DFT_COLOR=never git diff --ext-diff "$from" "$to" -- "$@"
  else
    git diff --function-context "$from" "$to" -- "$@"
  fi
}

load() { cat "$state/$1"; }
save() { printf '%s\n' "$2" >"$state/$1"; }

case $cmd in
init)
  (( $# == 3 )) || die "usage: tick.sh init <state-dir> <repo> <rules.yml> <progress-log>"
  mkdir -p "$state"
  save repo "$(cd "$1" && git rev-parse --show-toplevel)"
  save rules "$(realpath "$2")"
  save log "$(realpath -m "$3")"
  ;;
tick | final) ;;
*) die "unknown command: $cmd" ;;
esac

[[ -f $state/repo ]] || die "$state is not initialized; run tick.sh init first"
cd "$(load repo)"
rules=$(load rules)
command -v ast-grep >/dev/null || die "ast-grep not found; AST review is required"
command -v difft >/dev/null || echo "!! difft not found; falling back to git diff --function-context"

if [[ $cmd == init ]]; then
  base=$(snapshot)
  save base "$base"
  save prev "$base"
  save idle 0
  save log_seen 0
  : >"$state/reviewed.tsv"
  scan_hits >"$state/hits.base"
  cp "$state/hits.base" "$state/hits.prev"
  echo "baseline $base ($(wc -l <"$state/hits.base") rule hits)"
  exit 0
fi

base=$(load base)
cur=$(snapshot)

if [[ $cmd == final ]]; then
  echo "== final review: baseline ${base:0:10} -> ${cur:0:10}"
  echo "-- stat"; git diff --no-renames --stat "$base" "$cur"
  scan_hits >"$state/hits.cur"
  echo "-- rule hits since baseline"; print_hit_delta "$state/hits.base" "$state/hits.cur"
  echo "-- structural diff"; structural_diff "$base" "$cur"
  exit 0
fi

quiet=60 max_lines=300
while (( $# )); do
  case $1 in
  --quiet) quiet=$2; shift 2 ;;
  --max-lines) max_lines=$2; shift 2 ;;
  *) die "unknown option: $1" ;;
  esac
done

prev=$(load prev)
log=$(load log)
seen=$(load log_seen)
new_log=""
if [[ -f $log ]]; then
  new_log=$(tail -n +"$((seen + 1))" "$log")
  save log_seen "$(wc -l <"$log")"
fi

echo "== $(date +%T) baseline ${base:0:10} prev ${prev:0:10} cur ${cur:0:10}"

# Each file is reviewed from the tree it was last shown at (the baseline at first).
declare -A reviewed=()
while IFS=$'\t' read -r path tree; do
  [[ -n $path ]] && reviewed[$path]=$tree
done <"$state/reviewed.tsv"

declare -A candidates=()
while IFS= read -r path; do
  [[ -n $path ]] && candidates[$path]=1
done < <(git diff --no-renames --name-only "$base" "$cur"; printf '%s\n' "${!reviewed[@]}")

blob() { git rev-parse -q --verify "$1:$2" 2>/dev/null || true; }

# A file is ready once it changed since it was last shown and has been left
# alone for $quiet seconds; deleted files are ready immediately.
now=$(date +%s)
ready=() settling=()
for path in "${!candidates[@]}"; do
  [[ $(blob "${reviewed[$path]:-$base}" "$path") == "$(blob "$cur" "$path")" ]] && continue
  if [[ -e $path ]] && age=$(( now - $(stat -c %Y "$path") )) && (( age < quiet )); then
    settling+=("$path (modified ${age}s ago)")
  else
    ready+=("$path")
  fi
done

if [[ $cur == "$prev" && -z $new_log ]]; then
  idle=$(( $(load idle) + 1 ))
  echo "no change in the worktree or the progress log for $idle tick(s)"
else
  idle=0
fi
save idle "$idle"

if [[ $cur != "$prev" ]]; then
  echo "-- since baseline: $(git diff --no-renames --shortstat "$base" "$cur")"
  echo "-- since previous tick"; git diff --no-renames --stat "$prev" "$cur"
  scan_hits >"$state/hits.cur"
  echo "-- rule hits since previous tick"; print_hit_delta "$state/hits.prev" "$state/hits.cur"
  mv "$state/hits.cur" "$state/hits.prev"
  save prev "$cur"
fi

[[ -n $new_log ]] && { echo "-- progress log"; printf '%s\n' "$new_log"; }

if (( ${#settling[@]} )); then
  echo "-- settling, not reviewed yet"
  printf '%s\n' "${settling[@]}" | sort
fi

if (( ${#ready[@]} )); then
  echo "-- settled files: structural diff since last shown"
  shown=0 deferred=()
  while IFS= read -r path; do
    out=$(structural_diff "${reviewed[$path]:-$base}" "$cur" "$path")
    lines=$(wc -l <<<"$out")
    # Always show at least one file so an oversized diff cannot stall review.
    if (( shown > 0 && shown + lines > max_lines )); then
      deferred+=("$path")
      continue
    fi
    printf '%s\n' "$out"
    shown=$(( shown + lines ))
    reviewed[$path]=$cur
  done < <(printf '%s\n' "${ready[@]}" | sort)
  if (( ${#deferred[@]} )); then
    echo "deferred to the next tick (over $max_lines lines): ${deferred[*]}"
  fi
  for path in "${!reviewed[@]}"; do
    printf '%s\t%s\n' "$path" "${reviewed[$path]}"
  done >"$state/reviewed.tsv"
fi
