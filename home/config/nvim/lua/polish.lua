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

local function enable_osc52()
  local function _paste()
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
      ["+"] = _paste,
      ["*"] = _paste,
    },
  }
end

-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard:remove "unnamedplus"

  if
    vim.env.SSH_CLIENT
    or vim.env.SSH_TTY
    or (vim.env.WEZTERM_EXECUTABLE and vim.env.WEZTERM_EXECUTABLE:find "wezterm%-mux%-server")
  then
    enable_osc52()
  end
end)
