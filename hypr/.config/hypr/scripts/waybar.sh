#!/usr/bin/env bash
# restart waybar when it crashes

while true; do
    waybar &
    pid=$!
    # stay hidden in focus mode
    if [ "${crashed:-}" = 1 ] && [ "$(dunstctl is-paused)" = "true" ]; then
        sleep 1
        kill -USR1 "$pid"
    fi
    wait "$pid"
    code=$?
    # segfault or abort
    [ "$code" -eq 139 ] || [ "$code" -eq 134 ] || break
    crashed=1
    sleep 1
done
