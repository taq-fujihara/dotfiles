-- WIP

return {
  -- {
  --   "AstroNvim/astrolsp",
  --   ---@type AstroLSPOpts
  --   opts = {
  --     autocmds = {
  --       python_organize_import = {
  --         cond = "source.organizeImports.ruff",
  --         {
  --           event = { "BufWritePre" },
  --           desc = "Organize Import (buffer)",
  --           callback = function()
  --             vim.lsp.buf.code_action({
  --               apply = true,
  --               filter = function(action)
  --                 return action.kind == "source.organizeImports.ruff"
  --               end,
  --             })
  --           end,
  --         },
  --       },
  --     },
  --   },
  -- },
}
