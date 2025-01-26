local wezterm = require("wezterm")
local act = wezterm.action

local COLOR_SCHEME = "nord"

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
config.leader = { key = "f", mods = leader_key_mods, timeout_milliseconds = 1500 }

local function is_nvim(pane)
	return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find("nvim")
end

local function smart_pane_navigation(key, direction)
	return {
		key = key,
		mods = paneNavigationMods,
		action = wezterm.action_callback(function(window, pane)
			if is_nvim(pane) then
				window:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
			else
				window:perform_action({ ActivatePaneDirection = direction }, pane)
			end
		end)
	}
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

	-- workspaces
	{
		key = "w",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = 'Create Workspace',
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action({ SwitchToWorkspace = { name = line } }, pane)
				end
			end)
		})
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
	smart_pane_navigation('h', 'Left'),
	smart_pane_navigation('j', 'Down'),
	smart_pane_navigation('k', 'Up'),
	smart_pane_navigation('l', 'Right'),

	-- tab navigation
	{ key = "L",          mods = paneNavigationMods .. "|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "H",          mods = paneNavigationMods .. "|SHIFT", action = act.ActivateTabRelative(-1) },

	-- pane resizing
	{ key = "DownArrow",  mods = paneNavigationMods,             action = act.AdjustPaneSize({ "Down", 4 }) },
	{ key = "UpArrow",    mods = paneNavigationMods,             action = act.AdjustPaneSize({ "Up", 4 }) },
	{ key = "LeftArrow",  mods = paneNavigationMods,             action = act.AdjustPaneSize({ "Left", 8 }) },
	{ key = "RightArrow", mods = paneNavigationMods,             action = act.AdjustPaneSize({ "Right", 8 }) },

	{
		key = "S",
		mods = "LEADER",
		action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }),
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

	-- My Neovim, which does not recognize Shift+Space, will accept F20 as a key to trigger the completion
	-- This is a workaround for the issue...
	{
		key = "Space",
		mods = "SHIFT",
		action = act.SendKey({ key = "F20" }),
	},

	-- key tables
	{
		key = "t",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "tabs",
			one_shot = false,
		})
	},
	{
		key = "f",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "finder",
			one_shot = true,
		})
	},
}

config.key_tables = {
	tabs = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{
			key = "r",
			action = act.PromptInputLine({
				description = 'Enter new name for tab',
				action = wezterm.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end)
			})
		},
		{
			key = "Enter",
			action = 'PopKeyTable'
		}
	},
	finder = {
		{
			-- files
			key = "f",
			action = act.SendKey({ key = "f", mods = "ALT|CTRL" }),
		},
		{
			-- git logs
			key = "l",
			mods = "LEADER",
			action = act.SendKey({ key = "l", mods = "ALT|CTRL" }),
		},
		{
			-- workspaces
			key = "w",
			action = act.ShowLauncherArgs {
				flags = 'FUZZY|WORKSPACES',
			},
		}
	},
}

-- appearance

local ACTIVE_TAB_BG_COLOR = "NONE"
local ACTIVE_TAB_FG_COLOR = "NONE"
local INACTIVE_TAB_BG_COLOR = "NONE"
local INACTIVE_TAB_FG_COLOR = "NONE"

config.color_scheme = COLOR_SCHEME

if COLOR_SCHEME == "iceberg-dark" then
	ACTIVE_TAB_BG_COLOR = "#161821"
	ACTIVE_TAB_FG_COLOR = "#84a0c6"
	INACTIVE_TAB_FG_COLOR = "#84a0c6"
elseif COLOR_SCHEME == "Everforest Dark (Gogh)" then
	-- TODO
elseif COLOR_SCHEME == "Tokyo Night" then
	-- TODO
elseif COLOR_SCHEME == "Ayu Mirage" then
	ACTIVE_TAB_BG_COLOR = "#FFA726"
	ACTIVE_TAB_FG_COLOR = "#263238"
	INACTIVE_TAB_BG_COLOR = "#FFF3E0"
	INACTIVE_TAB_FG_COLOR = "#FFA726"
elseif COLOR_SCHEME == "nord" then
	ACTIVE_TAB_BG_COLOR = "#3b4252"
	ACTIVE_TAB_FG_COLOR = "#d8dee9"
	INACTIVE_TAB_FG_COLOR = "#607D8B"
end

config.line_height = 1.1
config.hide_tab_bar_if_only_one_tab = false -- I want workspace name to be always visible
config.window_background_opacity = 0.95
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.6,
}
config.window_decorations = "RESIZE"
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
	compose_cursor = "#A5D6A7",
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

wezterm.on('update-right-status', function(window)
	window:set_right_status(wezterm.format {
		{ Foreground = { Color = "#CFD8DC" } },
		{ Text = "      " .. window:active_workspace() .. "       " .. COLOR_SCHEME .. "    " },
	})
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.tab_title
	if not title or #title == 0 then
		title = tab.active_pane.title
	end
	if title == "~" then
		title = "● " .. title .. " ●"
	end

	local background = INACTIVE_TAB_BG_COLOR
	local foreground = INACTIVE_TAB_FG_COLOR
	local title_formatted = "  " .. title .. "  "

	if tab.is_active then
		background = ACTIVE_TAB_BG_COLOR
		foreground = ACTIVE_TAB_FG_COLOR
	end

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title_formatted },
	}
end)


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
