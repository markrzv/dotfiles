#!/usr/bin/env bash
# volume and brightness keys with a dunst progress bar

sink=@DEFAULT_AUDIO_SINK@
source=@DEFAULT_AUDIO_SOURCE@

case "$1" in
    volume-up)       wpctl set-volume -l 1 $sink 5%+ ;;
    volume-down)     wpctl set-volume $sink 5%- ;;
    volume-mute)     wpctl set-mute $sink toggle ;;
    mic-mute)        wpctl set-mute $source toggle ;;
    brightness-up)   brightnessctl -q -e4 -n2 set 5%+ ;;
    brightness-down) brightnessctl -q -e4 -n2 set 5%- ;;
esac

case "$1" in
    volume-*)
        output=$(wpctl get-volume $sink)
        value=$(awk '{printf "%d", $2 * 100 + 0.5}' <<< "$output")
        title="Volume $value%"
        [[ $output == *MUTED* ]] && title="Muted" && value=0
        ;;
    mic-mute)
        title="Microphone on"
        [[ $(wpctl get-volume $source) == *MUTED* ]] && title="Microphone muted"
        notify-send -a osd -t 1500 -h string:x-dunst-stack-tag:osd "$title"
        exit
        ;;
    brightness-*)
        value=$(brightnessctl -m | cut -d, -f4 | tr -d %)
        title="Brightness $value%"
        ;;
esac

notify-send -a osd -t 1500 -h string:x-dunst-stack-tag:osd -h int:value:"$value" "$title"
