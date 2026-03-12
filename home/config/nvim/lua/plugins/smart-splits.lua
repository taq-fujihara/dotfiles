return {
  "mrjones2014/smart-splits.nvim",
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Up>"] = { function() require("smart-splits").resize_up() end, desc = "Resize split up" }
        maps.n["<Down>"] = { function() require("smart-splits").resize_down() end, desc = "Resize split down" }
        maps.n["<Left>"] = { function() require("smart-splits").resize_left() end, desc = "Resize split left" }
        maps.n["<Right>"] = { function() require("smart-splits").resize_right() end, desc = "Resize split right" }
      end,
    },
  },
  opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
}
