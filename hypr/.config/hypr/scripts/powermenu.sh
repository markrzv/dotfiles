#!/usr/bin/env bash

choice=$(printf "lock\nsleep\nreboot\nshutdown\nlogout" | rofi -dmenu -i -p power)

case "$choice" in
    lock)     loginctl lock-session ;;
    sleep)    systemctl suspend ;;
    reboot)   systemctl reboot ;;
    shutdown) systemctl poweroff ;;
    logout)   hyprctl dispatch exit ;;
esac
