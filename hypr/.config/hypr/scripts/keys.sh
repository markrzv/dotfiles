#!/usr/bin/env bash
# list all binds with a description

hyprctl binds -j | python3 -c '
import json, sys
modifiers = [(64, "Super"), (4, "Ctrl"), (8, "Alt"), (1, "Shift")]
key_names = {"mouse:272": "Left click", "mouse:273": "Right click", "mouse_down": "Scroll down", "mouse_up": "Scroll up"}
rows = []
for bind in json.load(sys.stdin):
    if bind.get("description"):
        parts = [name for bit, name in modifiers if bind["modmask"] & bit] + [key_names.get(bind["key"], bind["key"].capitalize())]
        rows.append((" + ".join(parts), bind["description"]))
width = max(len(keys) for keys, _ in rows)
for keys, description in rows:
    print(f"{keys:<{width}}   {description}")
' | rofi -dmenu -i -p keys >/dev/null
