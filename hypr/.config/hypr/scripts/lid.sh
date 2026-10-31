#!/usr/bin/env bash
# only turn off the laptop screen when an external monitor is plugged in

laptop="eDP-1"

if [ "$1" = "close" ]; then
    hyprctl monitors | grep "^Monitor" | grep -qv "$laptop" && hyprctl keyword monitor "$laptop, disable"
else
    hyprctl keyword monitor "$laptop, preferred, auto, 1.25"
fi
