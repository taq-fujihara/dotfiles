return {
  "akinsho/toggleterm.nvim",
  opts = {
    float_opts = {
      border = "curved",
      width = function(_) return math.ceil(vim.o.columns * 0.9) end,
      height = function(_) return math.ceil(vim.o.lines * 0.9) end,
    },
  },
}
