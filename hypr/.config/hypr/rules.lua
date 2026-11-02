-- window class patterns, see hyprctl clients
local workspaces = {
    ["app.zen_browser.zen"] = "1",
    ["com.microsoft.VSCode|[Cc]ode"] = "2",
    ["com.anthropic.Claude"] = "2",
    ["[Dd]iscord"] = "3",
    ["[Ss]lack"] = "3",
    ["[Ss]potify"] = "4",
}

for class, workspace in pairs(workspaces) do
    hl.window_rule({ match = { class = "^(" .. class .. ")$" }, workspace = workspace })
end

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "settings-popups",
    match = { class = "^(blueman-manager|org.pulseaudio.pavucontrol|nm-connection-editor)$" },
    float = true,
    size = { 900, 600 },
    center = true,
})

hl.layer_rule({
    name = "waybar-blur",
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0.2,
})
