local mod = "SUPER"
local scripts = "~/.config/hypr/scripts/"

local function exec(cmd) return hl.dsp.exec_cmd(cmd) end

-- apps
hl.bind(mod .. " + Q", exec(apps.terminal))
hl.bind(mod .. " + E", exec(apps.fileManager))
hl.bind(mod .. " + B", exec(apps.browser))
hl.bind(mod .. " + T", exec(apps.code))
hl.bind(mod .. " + A", exec(apps.code .. " ~/dotfiles"))
hl.bind(mod .. " + D", exec("discord"))
hl.bind(mod .. " + L", exec(apps.menu))
hl.bind("Print", exec(scripts .. "screenshot.sh"))

-- windows
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- system
hl.bind(mod .. " + Escape", exec("loginctl lock-session"))
hl.bind(mod .. " + M", exec(scripts .. "powermenu.sh"))
hl.bind(mod .. " + R", exec("nmcli device wifi rescan"))
hl.bind(mod .. " + Space", exec("hyprctl switchxkblayout current next"))
hl.bind(mod .. " + SHIFT + T", exec("theme menu"))

-- workspaces, only 1 to 5
local max_workspace = 5

for i = 1, max_workspace do
    hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- stops at 1 and 5
local function step(direction, move)
    return function()
        local current = hl.get_active_workspace()
        local target = math.max(1, math.min(max_workspace, (current and current.id or 1) + direction))
        if move then
            hl.dispatch(hl.dsp.window.move({ workspace = target }))
        else
            hl.dispatch(hl.dsp.focus({ workspace = target }))
        end
    end
end

hl.bind("CTRL + ALT + right", step(1))
hl.bind("CTRL + ALT + left", step(-1))
hl.bind("CTRL + ALT + SHIFT + right", step(1, true))
hl.bind("CTRL + ALT + SHIFT + left", step(-1, true))
hl.bind(mod .. " + mouse_down", step(1))
hl.bind(mod .. " + mouse_up", step(-1))

-- scratchpad
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- volume, brightness
local held = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", exec(scripts .. "osd.sh volume-up"), held)
hl.bind("XF86AudioLowerVolume", exec(scripts .. "osd.sh volume-down"), held)
hl.bind("XF86AudioMute", exec(scripts .. "osd.sh volume-mute"), held)
hl.bind("XF86AudioMicMute", exec(scripts .. "osd.sh mic-mute"), held)
hl.bind("XF86MonBrightnessUp", exec(scripts .. "osd.sh brightness-up"), held)
hl.bind("XF86MonBrightnessDown", exec(scripts .. "osd.sh brightness-down"), held)

-- media
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

-- lid, super+p if the screen stays black
hl.bind("switch:on:Lid Switch", exec(scripts .. "lid.sh close"), { locked = true })
hl.bind("switch:off:Lid Switch", exec(scripts .. "lid.sh open"), { locked = true })
hl.bind(mod .. " + P", exec(scripts .. "lid.sh open"))
