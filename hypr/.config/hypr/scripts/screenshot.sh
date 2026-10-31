#!/usr/bin/env bash
# region screenshot, snap to whole pixels or it is blurry at 1.25x
set -euo pipefail

dir="$HOME/Pictures/Screenshots"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"
mkdir -p "$dir"

region=$(slurp -d) || exit 0
scale=$(hyprctl monitors | awk '/^Monitor/ {scale = ""} /scale:/ {scale = $2} /focused: yes/ {print scale; exit}')

region=$(awk -v region="$region" -v scale="$scale" 'BEGIN {
    split(region, parts, /[, x]/)
    for (step = 1; step < 16; step++) {
        diff = step * scale - int(step * scale + 0.5)
        if (diff < 0.01 && diff > -0.01) break
    }
    x1 = int(parts[1] / step) * step; y1 = int(parts[2] / step) * step
    x2 = parts[1] + parts[3]; y2 = parts[2] + parts[4]
    x2 = int((x2 + step - 1) / step) * step; y2 = int((y2 + step - 1) / step) * step
    printf "%d,%d %dx%d", x1, y1, x2 - x1, y2 - y1
}')

grim -g "$region" "$file"
wl-copy --type image/png < "$file"
notify-send -i "$file" "Screenshot" "Saved and copied"
