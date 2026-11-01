hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.25 })

-- used in binds.lua too
apps = {
    terminal    = "alacritty",
    fileManager = "thunar",
    browser     = "flatpak run app.zen_browser.zen",
    code        = "code",
    menu        = "rofi -show drun -auto-select",
}

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("~/.config/hypr/scripts/battery.sh")
    hl.exec_cmd(apps.browser)
    hl.exec_cmd(apps.code)
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    input = {
        kb_layout = "us, de",
        touchpad = {
            tap_and_drag = true,
            drag_lock = true,
        },
    },
})

hl.device({
    name = "06cbce44:00-06cb:cf00-touchpad",
    natural_scroll = true,
    tap_to_click = true,
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.config({ gestures = { workspace_swipe_create_new = false } })

require("look")
require("binds")
require("rules")
