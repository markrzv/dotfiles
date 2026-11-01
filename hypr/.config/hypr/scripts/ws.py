#!/usr/bin/env python3
# one workspace dot for waybar, the built-in module does not work with a lua config
import json
import os
import socket
import subprocess
import sys

workspace = int(sys.argv[1])
events = (
    b"workspace", b"focusedmon", b"createworkspace", b"destroyworkspace",
    b"openwindow", b"closewindow", b"movewindow", b"activespecial",
)


def query(what):
    return json.loads(subprocess.run(["hyprctl", "-j", what], capture_output=True, text=True).stdout)


def show():
    if query("activeworkspace")["id"] == workspace:
        state = "active"
    elif any(item["id"] == workspace and item["windows"] for item in query("workspaces")):
        state = "occupied"
    else:
        state = "empty"
    print(json.dumps({"text": " ", "class": state}), flush=True)


show()
path = f"{os.environ['XDG_RUNTIME_DIR']}/hypr/{os.environ['HYPRLAND_INSTANCE_SIGNATURE']}/.socket2.sock"
with socket.socket(socket.AF_UNIX) as sock:
    sock.connect(path)
    for line in sock.makefile("rb"):
        if line.startswith(events):
            show()
