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
ID_FILE="/tmp/claude-notify-id-${SESSION_ID}.txt"

get_window_id() {
    # Walk up process tree to find a window belonging to the terminal
    pid=$PPID
    while [ "$pid" != "1" ]; do
        wid=$(xdotool search --pid "$pid" 2>/dev/null | head -1)
        if [ -n "$wid" ]; then
            echo "$wid"
            return
        fi
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    done
    xdotool getactivewindow 2>/dev/null
}

send() {
    TITLE="${1:-Claude Code}"
    BODY="${2}"
    WINDOW_ID=$(get_window_id)

    # Read existing ID + kill previous background waiter
    OLD_ID=""
    OLD_BG_PID=""
    if [ -f "$STATE_FILE" ] && [ -s "$STATE_FILE" ]; then
        read OLD_ID OLD_WIN OLD_BG_PID < "$STATE_FILE"
        [ -n "$OLD_BG_PID" ] && kill "$OLD_BG_PID" 2>/dev/null
    fi

    ARGS=(-A "focus=開く" --id-fd 3)
    [ -n "$OLD_ID" ] && ARGS+=(-r "$OLD_ID")

    # Run notification with action in background
    (
        exec 3>"$ID_FILE"
        SELECTED=$(notify-send "${ARGS[@]}" "$TITLE" "$BODY" 2>/dev/null)
        if [ "$SELECTED" = "focus" ]; then
            if [ -f "$STATE_FILE" ]; then
                read _ WIN _ < "$STATE_FILE"
                [ -n "$WIN" ] && xdotool windowactivate "$WIN" 2>/dev/null
            fi
        fi
        rm -f "$ID_FILE"
    ) &
    BG_PID=$!

    # Wait for the ID to be written by notify-send
    for _ in $(seq 1 20); do
        [ -s "$ID_FILE" ] && break
        sleep 0.05
    done

    if [ -s "$ID_FILE" ]; then
        NEW_ID=$(cat "$ID_FILE")
        echo "$NEW_ID $WINDOW_ID $BG_PID" > "$STATE_FILE"
    fi
}

dismiss() {
    if [ -f "$STATE_FILE" ] && [ -s "$STATE_FILE" ]; then
        read OLD_ID OLD_WIN OLD_BG_PID < "$STATE_FILE"
        [ -n "$OLD_BG_PID" ] && kill "$OLD_BG_PID" 2>/dev/null
        gdbus call --session \
            --dest org.freedesktop.Notifications \
            --object-path /org/freedesktop/Notifications \
            --method org.freedesktop.Notifications.CloseNotification "$OLD_ID" \
            2>/dev/null
        rm -f "$STATE_FILE" "$ID_FILE"
    fi
}

if [ "$1" = "--dismiss" ]; then
    dismiss
else
    send "$1" "$2"
fi
