local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

require("appearance").setup(config)

config.hide_tab_bar_if_only_one_tab = true

config.disable_default_key_bindings = true
config.keys = {
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = act.PasteFrom("Clipboard"),
	},
}

config.default_prog = { "herdr" }

return config
