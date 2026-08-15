local wezterm = require("wezterm") --[[@as Wezterm]]
local act = wezterm.action

M = {}
function M.setup(config)
	config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1500 }

	config.keys = {
		-- Disable default key assignments

		{
			key = "p",
			mods = "CTRL|SHIFT",
			action = act.DisableDefaultAssignment,
		},

		{
			key = "p",
			mods = "LEADER",
			action = act.ActivateCommandPalette,
		},

		-- Workspaces

		{
			key = "w",
			mods = "LEADER",
			action = act.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
		{
			key = "W",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Create Workspace",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:perform_action({ SwitchToWorkspace = { name = line } }, pane)
					end
				end),
			}),
		},

		-- Tabs

		{
			key = "n",
			mods = "LEADER",
			action = act.SpawnTab("CurrentPaneDomain"),
		},

		{ key = "h", mods = "LEADER", action = act.ActivateTabRelative(-1) },
		{ key = "l", mods = "LEADER", action = act.ActivateTabRelative(1) },
		{ key = "H", mods = "LEADER", action = act.MoveTabRelative(-1) },
		{ key = "L", mods = "LEADER", action = act.MoveTabRelative(1) },

		{
			key = "t",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},

		-- Panes

		{
			key = "|",
			mods = "LEADER|SHIFT",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		{ key = "H", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
		{ key = "J", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
		{ key = "K", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
		{ key = "L", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },

		{ key = "r", mods = "LEADER", action = act.RotatePanes("Clockwise") },

		{ key = "DownArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "UpArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "LeftArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 10 }) },
		{ key = "RightArrow", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 10 }) },

		{
			key = "z",
			mods = "LEADER",
			action = act.TogglePaneZoomState,
		},

		{
			key = "S",
			mods = "LEADER",
			action = act.PaneSelect({ mode = "SwapWithActive" }),
		},

		--

		{
			key = "v",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},
		{
			key = "s",
			mods = "LEADER",
			action = act.QuickSelect,
		},

		-- for fish: accept autocomplete and execute
		{
			key = "raw:36",
			mods = "SHIFT",
			action = act.Multiple({
				act.SendKey({ key = "RightArrow" }),
				act.SendKey({ key = "\r" }),
			}),
		},

		-- My Neovim, which does not recognize Shift+Space, will accept F20 as a key to trigger the completion
		-- This is a workaround for the issue...
		{
			key = "Space",
			mods = "SHIFT",
			action = act.SendKey({ key = "F20" }),
		},
	}
end

return M
