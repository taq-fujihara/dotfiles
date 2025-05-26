return {
  "folke/flash.nvim",
  event = "VeryLazy",
  version = "*",
  opts = {},
  config = function()
    vim.api.nvim_set_hl(0, "FlashCurrent", { foreground = '#ffffff', background = '#1976D2' })
    vim.api.nvim_set_hl(0, "FlashLabel", { foreground = '#ffffff', background = '#E91E63' })
    vim.api.nvim_set_hl(0, "FlashMatch", { foreground = '#ffffff', background = '#1976D2' })
  end,
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump({
          search = {
            mode = function(str)
              return "\\<" .. str
            end,
          },
          label = {
            uppercase = false,
          },
          autojump = true,
        })
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
