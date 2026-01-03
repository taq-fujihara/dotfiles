local wezterm = require("wezterm")

local act = wezterm.action
local is_mac = wezterm.target_triple == "x86_64-apple-darwin"

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

config.font = wezterm.font('UDEV Gothic 35NFLG')
config.line_height = 1.2

config.hide_tab_bar_if_only_one_tab = false -- I want workspace name to be always visible
config.window_background_opacity = 0.95
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.6,
}
config.window_decorations = "NONE"
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
		{ Text = "   " .. inactive_workspace_text .. "   " },
		{ Text = "   " .. COLOR_SCHEME .. "   " },
	})
end)

-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
-- https://www.nerdfonts.com/cheat-sheet
local icons = {
	["bat"] = wezterm.nerdfonts.md_bat,
	-- ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	-- ["cargo"] = wezterm.nerdfonts.dev_rust,
	-- ["curl"] = wezterm.nerdfonts.mdi_flattr,
	["docker"] = wezterm.nerdfonts.linux_docker,
	["fish"] = wezterm.nerdfonts.md_fish,
	["gh"] = wezterm.nerdfonts.cod_github_inverted,
	["git"] = wezterm.nerdfonts.dev_git,
	-- ["go"] = wezterm.nerdfonts.seti_go,
	-- ["htop"] = wezterm.nerdfonts.md_chart_areaspline,
	-- ["btop"] = wezterm.nerdfonts.md_chart_areaspline,
	-- ["kubectl"] = wezterm.nerdfonts.linux_docker,
	-- ["kuberlr"] = wezterm.nerdfonts.linux_docker,
	["lazydocker"] = wezterm.nerdfonts.linux_docker,
	["lua"] = wezterm.nerdfonts.md_language_lua,
	-- ["make"] = wezterm.nerdfonts.seti_makefile,
	["node"] = wezterm.nerdfonts.md_nodejs,
	["nvim"] = "󰕷",
	["python"] = wezterm.nerdfonts.md_language_python,
	["psql"] = wezterm.nerdfonts.dev_postgresql,
	-- ["ruby"] = wezterm.nerdfonts.cod_ruby,
	-- ["sudo"] = wezterm.nerdfonts.fa_hashtag,
	["wget"] = wezterm.nerdfonts.md_cloud_download,
	["lazygit"] = wezterm.nerdfonts.cod_github,
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.tab_title
	if not title or #title == 0 then
		title = tab.active_pane.title
	end

	local process, other = title:match("^(%S+)%s*(.*)$")

	if process == "fish" and other == "~" then
		-- "󰡮", "󰈈", "", "󰮔", "󰮕", "", "",
		local eye = "󰡮"
		title = eye .. "  " .. other .. " " .. eye
	elseif icons[process] then
		title = icons[process] .. "   " .. other
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
