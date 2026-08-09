local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

require("appearance").setup(config)

config.enable_kitty_keyboard = false
config.hide_tab_bar_if_only_one_tab = true

config.disable_default_key_bindings = true
config.keys = {
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = act.PasteFrom("Clipboard"),
	},
}

-- not working...
wezterm.on("user-var-changed", function(window, pane, name, value)
	wezterm.log_info("USER VAR CHANGED:", name, value)
	if name == "wezterm_action" and value == "quickselect" then
		window:perform_action(act.QuickSelect, pane)
	end
end)

config.default_prog = { "herdr" }

local has_override, apply_to_config = pcall(require, "override")
if has_override then
	apply_to_config(config)
end

return config
