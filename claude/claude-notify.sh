#!/bin/bash
# Per-session notification manager for Claude Code
# Uses PPID (the .claude-wrapped process) as session identifier
# so each Claude session manages its own notifications independently
#
# Usage:
#   claude-notify.sh "title" "body"   - send/replace notification
#   claude-notify.sh --dismiss        - close the notification

SESSION_ID="$PPID"
STATE_FILE="/tmp/claude-notify-${SESSION_ID}.txt"

send() {
    TITLE="${1:-Claude Code}"
    BODY="${2}"
    TIMEOUT="${3:-}"

    OPTS="-p"
    [ -f "$STATE_FILE" ] && [ -s "$STATE_FILE" ] && OPTS="$OPTS -r $(cat "$STATE_FILE")"
    [ -n "$TIMEOUT" ] && OPTS="$OPTS -t $TIMEOUT"

    NEW_ID=$(notify-send $OPTS "$TITLE" "$BODY" 2>/dev/null)

    if [ -n "$TIMEOUT" ]; then
        rm -f "$STATE_FILE"
    elif [ -n "$NEW_ID" ]; then
        echo "$NEW_ID" > "$STATE_FILE"
    fi
}

dismiss() {
    if [ -f "$STATE_FILE" ] && [ -s "$STATE_FILE" ]; then
        ID=$(cat "$STATE_FILE")
        gdbus call --session \
            --dest org.freedesktop.Notifications \
            --object-path /org/freedesktop/Notifications \
            --method org.freedesktop.Notifications.CloseNotification "$ID" \
            2>/dev/null
        rm -f "$STATE_FILE"
    fi
}

if [ "$1" = "--dismiss" ]; then
    dismiss
else
    send "$1" "$2"
fi
