---@type LazySpec
return {
  "Saghen/blink.cmp",
  version = "1.*",
  opts = {
    keymap = {
      -- Wezterm sends <F20> for Shift+Space, which neovim doesn't recognize
      ["<F20>"] = { "show", "show_documentation", "hide_documentation" },
    },
  },
}
