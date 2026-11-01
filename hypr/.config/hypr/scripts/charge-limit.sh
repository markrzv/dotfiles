#!/usr/bin/env bash
# switch the charge limit, Long_Life is 80%, Standard is 100%
# needs once: echo "$USER ALL=(root) NOPASSWD: /usr/bin/tee /sys/class/power_supply/BAT0/charge_types" | sudo EDITOR=tee visudo -f /etc/sudoers.d/charge-limit

file=/sys/class/power_supply/BAT0/charge_types
pending="$XDG_RUNTIME_DIR/charge-limit"

current() { grep -o '\[[^]]*\]' "$file" | tr -d '[]'; }
label() { if [ "$1" = Long_Life ]; then echo 80%; else echo 100%; fi; }
show() { notify-send -a osd -t 3000 -h string:x-dunst-stack-tag:osd "$@"; }

if [ "${1:-}" = status ]; then
    show "Charge limit: $(label "$(current)")"
    exit
fi

target=$(cat "$pending" 2>/dev/null || current)
if [ "$target" = Long_Life ]; then target=Standard; else target=Long_Life; fi
echo "$target" > "$pending"
echo $$ > "$pending.pid"
show "Charge limit: $(label "$target")" "Applies in 3 seconds"

sleep 3

# stop if clicked again
[ "$(cat "$pending.pid")" = "$$" ] || exit 0
rm -f "$pending" "$pending.pid"

if [ "$target" = "$(current)" ] || echo "$target" | sudo -n tee "$file" >/dev/null 2>&1; then
    show "Charge limit set: $(label "$(current)")"
else
    show "Charge limit not changed" "Sudo rule missing, see charge-limit.sh"
fi
