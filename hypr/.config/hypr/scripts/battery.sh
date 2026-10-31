#!/usr/bin/env bash
# notify at 20% and 10%

battery=/sys/class/power_supply/BAT0
warned=100

while true; do
    level=$(cat "$battery/capacity")

    if [ "$(cat "$battery/status")" != "Discharging" ]; then
        warned=100
    elif [ "$level" -le 10 ] && [ "$warned" -gt 10 ]; then
        notify-send -a battery -u critical -h int:value:"$level" "Battery critical" "$level%, plug in now"
        warned=10
    elif [ "$level" -le 20 ] && [ "$warned" -gt 20 ]; then
        notify-send -a battery -h int:value:"$level" "Battery low" "$level%"
        warned=20
    fi

    sleep 60
done
