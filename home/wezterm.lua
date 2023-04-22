local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function is_nvim(pane)
  return pane:get_foreground_process_name():find('nvim') ~= nil
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
}

config.color_scheme = 'Ayu Mirage'
-- config.color_scheme = 'nord'
config.window_background_opacity = 0.95
config.font = wezterm.font 'Lotion500 Nerd Font'
-- config.font = wezterm.font 'FiraCode Nerd Font'
config.line_height = 1.1

return config
