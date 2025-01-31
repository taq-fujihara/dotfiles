local wezterm = require("wezterm") --[[@as Wezterm]]
local act = wezterm.action

M = {}

local leader_key_mods = "CTRL"
local paneNavigationMods = "CTRL"

if wezterm.target_triple == "x86_64-apple-darwin" then
  leader_key_mods = "CMD"
  paneNavigationMods = "CMD"
end

function M.setup(config)
  -- Leader key
  config.leader = { key = "f", mods = leader_key_mods, timeout_milliseconds = 1500 }

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
      action = act.ShowLauncherArgs {
        flags = 'FUZZY|WORKSPACES',
      },
    },
    {
      key = "W",
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
    M.smart_pane_navigation('h', 'Left'),
    M.smart_pane_navigation('j', 'Down'),
    M.smart_pane_navigation('k', 'Up'),
    M.smart_pane_navigation('l', 'Right'),

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
      -- {
      -- 	-- workspaces
      -- 	key = "w",
      -- 	action = act.ShowLauncherArgs {
      -- 		flags = 'FUZZY|WORKSPACES',
      -- 	},
      -- }
    },
  }
end

function M.smart_pane_navigation(key, direction)
  return {
    key = key,
    mods = paneNavigationMods,
    action = wezterm.action_callback(function(window, pane)
      if M.is_nvim(pane) then
        window:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
      else
        window:perform_action({ ActivatePaneDirection = direction }, pane)
      end
    end)
  }
end

function M.is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find("nvim")
end

return M
