---@type LazySpec
return {
  "Saghen/blink.cmp",
  opts = {
    keymap = {
      -- Wezterm sends <F20> for Shift+Space, which neovim doesn't recognize
      ["<F20>"] = { "show", "show_documentation", "hide_documentation" },
    },
  },
}
