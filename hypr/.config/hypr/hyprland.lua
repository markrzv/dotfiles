local function output_of(cmd)
    local process = io.popen(cmd)
    local output = process:read("a")
    process:close()
    return output
end

-- runs again on reload, keep the laptop screen off
local lid_closed = output_of("cat /proc/acpi/button/lid/*/state"):find("closed")
local has_external = output_of("grep -lx connected /sys/class/drm/*/status | grep -v eDP") ~= ""

hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })
if lid_closed and has_external then
    hl.monitor({ output = "eDP-1", disabled = true })
else
    hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.25 })
end

-- used in binds.lua too
apps = {
    terminal    = "alacritty",
    fileManager = "thunar",
    browser     = "flatpak run app.zen_browser.zen",
    code        = "code",
    menu        = "rofi -show drun -auto-select",
}

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/waybar.sh")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("bluetoothctl power off")
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
