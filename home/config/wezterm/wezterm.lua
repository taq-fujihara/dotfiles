local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local paneNavigationMods = "CTRL"
config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 2000 }

-- Mac specific override
if wezterm.target_triple == "x86_64-apple-darwin" then
	config.leader = { key = "f", mods = "CMD", timeout_milliseconds = 2000 }
	paneNavigationMods = "CMD"
end

config.keys = {
	-- disable Command + f (search) to use it as Leader key
	{
		key = "f",
		mods = "CMD",
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
		key = "t",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "T",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
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
}

-- config.color_scheme = "Ayu Mirage"
config.color_scheme = "Everforest Dark (Gogh)"
-- config.color_scheme = 'iceberg-dark'
-- config.color_scheme = 'Tokyo Night'
-- config.color_scheme = 'Tokyo Night Storm'
-- config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'Catppuccin Macchiato'
-- config.color_scheme = 'Papercolor Dark (Gogh)'
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
-- local apply_to_config = require 'override'
-- apply_to_config(config)

return config

-- -- Deprecated
--
-- local function is_nvim(pane)
--   -- cannot get process name when connect to host via ssh
--   -- https://wezfurlong.org/wezterm/config/lua/pane/get_foreground_process_name.html?h=get_foreground_process_name
--   local process_name = pane:get_foreground_process_name()
--   if process_name == nil then
--     return false
--   end
--   return process_name:find('nvim') ~= nil
-- end
-- -- Deprecated
-- local function activatePaneDirection(key, direction)
--   return {
--     key = key,
--     mods = 'CTRL',
--     action = wezterm.action_callback(function(win, pane)
--       if is_nvim(pane) then
--         win:perform_action({ SendKey = { key = key, mods = 'CTRL' }}, pane)
--       else
--         win:perform_action({ ActivatePaneDirection = direction }, pane)
--       end
--     end)
--   }
-- end
