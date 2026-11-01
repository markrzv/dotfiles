#!/usr/bin/env bash
# focus mode: hide the bar and pause notifications

if [ "$(dunstctl is-paused)" = "true" ]; then
    dunstctl set-paused false
else
    dunstctl set-paused true
fi

pkill -SIGUSR1 -x waybar
