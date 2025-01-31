local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

require("keys").setup(config)

-- appearance

local COLOR_SCHEME = "nord"

local ACTIVE_TAB_BG_COLOR = "NONE"
local ACTIVE_TAB_FG_COLOR = "NONE"
local INACTIVE_TAB_BG_COLOR = "NONE"
local INACTIVE_TAB_FG_COLOR = "NONE"

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

config.color_scheme = COLOR_SCHEME
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

wezterm.on('update-status', function(window)
	local active_workspace = window:active_workspace()

	window:set_left_status(wezterm.format {
		{ Foreground = { Color = ACTIVE_TAB_FG_COLOR } },
		{ Text = "      " .. active_workspace .. "  " },
	})

	local workspaces = wezterm.mux.get_workspace_names()
	local MAX_INACTIVE_WORKSPACES = 3
	local inactive_workspaces = {}
	local count = 0

	for _, ws in ipairs(workspaces) do
		if ws ~= active_workspace then
			table.insert(inactive_workspaces, ws)
		end
		count = count + 1
		if count >= MAX_INACTIVE_WORKSPACES then
			break
		end
	end

	local inactive_workspace_text = table.concat(inactive_workspaces, ", ")

	local hidden_count = #workspaces - count - 1 -- -1 for active workspace
	if hidden_count > 0 then
		inactive_workspace_text = inactive_workspace_text .. " +" .. hidden_count
	end

	window:set_right_status(wezterm.format {
		{ Foreground = { Color = INACTIVE_TAB_FG_COLOR } },
		{ Text = "      " .. inactive_workspace_text .. "       " .. COLOR_SCHEME .. "    " },
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
