#!/bin/zsh
# Usage: ide [TOP BOTTOM]
#
# Arrange the current pane into two rows: TOP panes above, BOTTOM panes below.
# With counts given, both rows get the same height and each row is divided
# into equal columns. Without arguments, one large pane sits above three.

usage() {
  print -u2 'usage: ide [TOP BOTTOM]  (pane counts, each 1 or more)'
  exit 2
}

case $# in
  0) top=1 bottom=3 top_percent=70 ;;
  2) top=$1 bottom=$2 top_percent=50 ;;
  *) usage ;;
esac
for count in $top $bottom; do
  [[ $count == <1-> ]] || usage
done

# Divide pane $1 into $2 equal columns; pane $1 stays leftmost.
split_columns() {
  local pane=$1 remaining
  for (( remaining = $2; remaining > 1; remaining-- )); do
    # The new pane takes everything but one column's share, rounded to nearest.
    pane=$(wezterm cli split-pane --pane-id $pane --right \
      --percent $(( (100 * (remaining - 1) + remaining / 2) / remaining ))) || exit
  done
}

bottom_pane=${WEZTERM_PANE:?ide must run inside a WezTerm pane}
top_pane=$(wezterm cli split-pane --pane-id $bottom_pane --top --percent $top_percent) || exit

split_columns $top_pane $top
split_columns $bottom_pane $bottom

wezterm cli activate-pane --pane-id $top_pane
