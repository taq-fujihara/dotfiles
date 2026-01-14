-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE", ctermbg = "NONE" })

vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { link = "Normal" })

vim.filetype.add {
  extension = {
    tofu = "terraform",
  },
}

-- Clipboard handling for remote WezTerm sessions
-- https://github.com/wezterm/wezterm/discussions/5231#discussioncomment-12242182

-- Sync clipboard between OS and Neovim.
-- Function to set OSC 52 clipboard
local function set_osc52_clipboard()
  local function my_paste()
    local content = vim.fn.getreg '"'
    return vim.split(content, "\n")
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = my_paste,
      ["*"] = my_paste,
    },
  }
end

-- Check if the current session is a remote WezTerm session based on the WezTerm executable
local function check_wezterm_remote_clipboard(callback)
  local wezterm_executable = vim.uv.os_getenv "WEZTERM_EXECUTABLE"

  if wezterm_executable and wezterm_executable:find("wezterm-mux-server", 1, true) then
    callback(true) -- Remote WezTerm session found
  else
    callback(false) -- No remote WezTerm session
  end
end

-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard:append "unnamedplus"

  -- Standard SSH session handling
  if vim.uv.os_getenv "SSH_CLIENT" ~= nil or vim.uv.os_getenv "SSH_TTY" ~= nil then
    set_osc52_clipboard()
  else
    check_wezterm_remote_clipboard(function(is_remote_wezterm)
      if is_remote_wezterm then set_osc52_clipboard() end
    end)
  end
end)
