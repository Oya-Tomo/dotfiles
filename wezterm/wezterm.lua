local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		-- Tab Operation Shortcut
		{ key = "t", mods = "ALT", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "q", mods = "ALT", action = act({ CloseCurrentTab = { confirm = true } }) },
		{ key = "b", mods = "ALT", action = act({ ActivateTabRelative = -1 }) },
		{ key = "n", mods = "ALT", action = act({ ActivateTabRelative = 1 }) },
		{ key = "b", mods = "ALT|SHIFT", action = act({ MoveTabRelative = -1 }) },
		{ key = "n", mods = "ALT|SHIFT", action = act({ MoveTabRelative = 1 }) },
		{ key = "1", mods = "ALT", action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "ALT", action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "ALT", action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "ALT", action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "ALT", action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "ALT", action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "ALT", action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "ALT", action = act({ ActivateTab = 7 }) },
		{ key = "9", mods = "ALT", action = act({ ActivateTab = 8 }) },
		-- Pane Operation Shortcut
		{ key = "h", mods = "CTRL", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = "v", mods = "CTRL", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "q", mods = "CTRL", action = act({ CloseCurrentPane = { confirm = true } }) },
		{ key = "n", mods = "CTRL", action = act({ ActivatePaneDirection = "Next" }) },
		{ key = "b", mods = "CTRL", action = act({ ActivatePaneDirection = "Prev" }) },
		{ key = "h", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Left", 1 } }) },
		{ key = "l", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Right", 1 } }) },
		{ key = "k", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Up", 1 } }) },
		{ key = "j", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Down", 1 } }) },
		-- Clipboard Operation Shortcut
		{ key = "c", mods = "CTRL|SHIFT", action = act({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CTRL|SHIFT", action = act({ PasteFrom = "Clipboard" }) },
	},
	color_scheme = "Darkside",
    font = wezterm.font_with_fallback({"Hack"}),
    -- use_ime = true,
}
