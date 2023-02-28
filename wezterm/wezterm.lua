local wezterm = require("wezterm")

-- Alias Operation Custom Event
wezterm.on("ide", function(window, pane)
    window:perform_action(
        wezterm.action.SplitPane({
            direction = 'Down',
            size = { Percent = 30 },
        }),
        pane
    )
    window:perform_action(
        wezterm.action.SplitPane({
            direction = 'Right',
            size = { Percent = 70 },
        }),
        pane
    )
    window:perform_action(
        wezterm.action.SplitPane({
            direction = 'Right',
            size = { Percent = 50 },
        }),
        pane
    )
end)

return {
    leader = { key = 'l', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = {
        -- Tab Operation Shortcut
        { key = "t", mods = "ALT",       action = wezterm.action.SpawnTab("CurrentPaneDomain"), },
        { key = "q", mods = "ALT",       action = wezterm.action.CloseCurrentTab({ confirm = true }), },
        { key = "b", mods = "ALT",       action = wezterm.action.ActivateTabRelative( -1), },
        { key = "n", mods = "ALT",       action = wezterm.action.ActivateTabRelative(1), },
        { key = "b", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative( -1), },
        { key = "n", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative(1), },
        -- Pane Operation Shortcut
        {
            key = 'h',
            mods = 'CTRL',
            action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
        },
        {
            key = 'v',
            mods = 'CTRL',
            action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }),
        },
        { key = "q", mods = "CTRL",       action = wezterm.action.CloseCurrentPane({ confirm = true }), },
        { key = "n", mods = "CTRL",       action = wezterm.action.ActivatePaneDirection('Next'), },
        { key = "b", mods = "CTRL",       action = wezterm.action.ActivatePaneDirection("Prev"), },
        { key = "h", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }), },
        { key = "l", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }), },
        { key = "k", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }), },
        { key = "j", mods = "CTRL|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }), },
        -- Clipboard Operation Shortcut
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard"), },
        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard"), },
        -- Alias Shortcut
        { key = "i", mods = "CTRL|ALT",   action = wezterm.action.EmitEvent("ide"), }
    },
    color_scheme = "Darkside",
    font = wezterm.font_with_fallback({ "Hack" }),
    -- use_ime = true,
}
