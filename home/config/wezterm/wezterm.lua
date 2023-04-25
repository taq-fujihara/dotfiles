local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function is_nvim(pane)
  -- cannot get process name when connect to host via ssh
  -- https://wezfurlong.org/wezterm/config/lua/pane/get_foreground_process_name.html?h=get_foreground_process_name
  local process_name = pane:get_foreground_process_name()
  if process_name == nil then
    return false
  end
  return process_name:find('nvim') ~= nil
end

local function activatePaneDirection(key, direction)
  return {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_nvim(pane) then
        win:perform_action({ SendKey = { key = key, mods = 'CTRL' }}, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction }, pane)
      end
    end)
  }
end

config.leader = { key = 'f', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  activatePaneDirection('j', 'Down'),
  activatePaneDirection('k', 'Up'),
  activatePaneDirection('h', 'Left'),
  activatePaneDirection('l', 'Right'),
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize{ 'Down', 4 },
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize{ 'Up', 4 },
  },
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize{ 'Left', 8 },
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize{ 'Right', 8 },
  },
  {
    key = 'v',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
}

config.color_scheme = 'Ayu Mirage'
config.line_height = 1.1

config.hide_tab_bar_if_only_one_tab = true

config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.4,
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
local has_override, apply_to_config = pcall(require, 'override')
if has_override then
  apply_to_config(config)
end

return config
