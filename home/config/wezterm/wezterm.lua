local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local leader_key_mods = "CTRL"
local paneNavigationMods = "CTRL"

if wezterm.target_triple == "x86_64-apple-darwin" then
	leader_key_mods = "CMD"
	paneNavigationMods = "CMD"
end

-- Leader key
config.leader = { key = "f", mods = leader_key_mods, timeout_milliseconds = 2000 }

config.keys = {
	-- disable Command + f (search) to use it as Leader key
	{
		key = "f",
		mods = "CMD",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.DisableDefaultAssignment,
	},

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

	-- split pane
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

	-- pane navigation
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	--
	{
		key = "LeftArrow",
		mods = paneNavigationMods,
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "DownArrow",
		mods = paneNavigationMods,
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "UpArrow",
		mods = paneNavigationMods,
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "RightArrow",
		mods = paneNavigationMods,
		action = act.ActivatePaneDirection("Right"),
	},
	-- was not good
	-- activatePaneDirection('j', 'Down'),
	-- activatePaneDirection('k', 'Up'),
	-- activatePaneDirection('h', 'Left'),
	-- activatePaneDirection('l', 'Right'),

	-- tab navigation
	{
		key = "L",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "H",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},

	-- pane resizing
	{
		key = "DownArrow",
		mods = paneNavigationMods .. "|SHIFT",
		action = act.AdjustPaneSize({ "Down", 4 }),
	},
	{
		key = "UpArrow",
		mods = paneNavigationMods .. "|SHIFT",
		action = act.AdjustPaneSize({ "Up", 4 }),
	},
	{
		key = "LeftArrow",
		mods = paneNavigationMods .. "|SHIFT",
		action = act.AdjustPaneSize({ "Left", 8 }),
	},
	{
		key = "RightArrow",
		mods = paneNavigationMods .. "|SHIFT",
		action = act.AdjustPaneSize({ "Right", 8 }),
	},

	--
	{
		key = "v",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
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

	{
		key = "l",
		mods = "LEADER",
		action = act.SendKey({ key = "l", mods = "ALT|CTRL" }),
	},
	{
		key = "f",
		mods = "LEADER",
		action = act.SendKey({ key = "f", mods = "ALT|CTRL" }),
	},

	-- My Neovim, which does not recognize Shift+Space, will accept F20 as a key to trigger the completion
	-- This is a workaround for the issue...
	{
		key = "Space",
		mods = "SHIFT",
		action = act.SendKey({ key = "F20" }),
	},
}

config.color_scheme = "Everforest Dark (Gogh)"
config.line_height = 1.1

config.hide_tab_bar_if_only_one_tab = true

config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.5,
}

-- override.lua template
-- ```
-- local wezterm = require 'wezterm'
-- local function apply_to_config(config)
--   -- settings per environment here
--   config.font = wezterm.font 'Lotion500 Nerd Font'
--   config.window_background_opacity = 0.95
-- end
-- return apply_to_config
-- ```
local has_override, apply_to_config = pcall(require, "override")
if has_override then
	apply_to_config(config)
end

return config
