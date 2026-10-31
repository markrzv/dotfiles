local workspaces = {
    ["app.zen_browser.zen"] = "1",
    code = "2",
    discord = "3",
    Slack = "3",
    spotify = "4",
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
