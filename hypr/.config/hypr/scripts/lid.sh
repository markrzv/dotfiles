#!/usr/bin/env bash
# only turn off the laptop screen when an external monitor is plugged in

laptop="eDP-1"

if [ "$1" = "close" ]; then
    hyprctl monitors | grep "^Monitor" | grep -qv "$laptop" &&
        hyprctl eval "hl.monitor({ output = \"$laptop\", disabled = true })"
else
    hyprctl eval "hl.monitor({ output = \"$laptop\", mode = \"preferred\", position = \"auto\", scale = 1.25 })"
fi
