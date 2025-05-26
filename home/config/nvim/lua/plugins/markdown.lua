return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  keys = {
    { "<Leader>mt", ":RenderMarkdown toggle<CR>", desc = "Toggle RenderMarkdown" },
  },
  ---@module "render-markdown"
  ---@type render.md.UserConfig
  opts = {
    blink = { enabled = true },
    completions = { lsp = { enabled = true } },
    render_modes = true,
    win_options = {
      showbreak = {
        default = '',
        rendered = '  ',
      },
      breakindent = {
        default = false,
        rendered = true,
      },
      breakindentopt = {
        default = '',
        rendered = '',
      },
    },
    heading = {
      width = { "full", "block" },
      icons = { "", "", "", "", "", "" },
      min_width = 60,
      right_pad = 2,
      left_pad = 0,
    },
    code = {
      sign = false,
      width = "block",
      min_width = 80,
      right_pad = 2,
      left_pad = 2,
      position = "right",
      border = 'thick',
    },
    checkbox = {
      unchecked = {
        icon = " "
      },
      checked = {
        icon = " ",
        scope_highlight = "@markup.strikethrough",
      },
      custom = {
        cancel = {
          raw = "[~]",
          rendered = "󰜺 ",
          scope_highlight = "@markup.strikethrough",
        }
      },
    },
    quote = {
      repeat_linebreak = true,
    },
    pipe_table = {
      preset = "round",
    },
  },
}
