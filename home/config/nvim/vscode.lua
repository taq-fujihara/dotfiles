local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

require("lazy").setup {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump {
            search = {
              mode = function(str) return "\\<" .. str end,
            },
            label = {
              uppercase = false,
            },
            autojump = true,
          }
        end,
        desc = "Flash",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "xiyaowong/fast-cursor-move.nvim",
    version = "*",
    event = "VeryLazy",
    config = function() vim.g.fast_cursor_move_acceleration = false end,
  },
}

-- local code = require("vscode")

vim.keymap.set("n", ";", ":")
vim.keymap.set("v", ";", ":")

vim.keymap.set("n", "|", "<Cmd>lua require('vscode').action('workbench.action.splitEditor')<CR>")
vim.keymap.set("n", "-", "<Cmd>lua require('vscode').action('workbench.action.splitEditorDown')<CR>")
vim.keymap.set("n", "L", "<Cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>")
vim.keymap.set("n", "H", "<Cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>")
vim.keymap.set("n", "za", "<Cmd>lua require('vscode').action('editor.toggleFold')<CR>")

vim.keymap.set("n", "<Leader>w", "<Cmd>lua require('vscode').action('workbench.action.files.save')<CR>")
vim.keymap.set("n", "<Leader>c", "<Cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>")
vim.keymap.set("n", "<Leader>q", "<Cmd>lua require('vscode').action('workbench.action.closeActiveEditor')<CR>")
vim.keymap.set("n", "<Leader>n", "<Cmd>lua require('vscode').action('workbench.action.files.newUntitledFile')<CR>")

vim.keymap.set("n", "<Leader>/", "<Cmd>lua require('vscode').action('editor.action.commentLine')<CR>")
vim.keymap.set("v", "<Leader>/", "<Cmd>lua require('vscode').action('editor.action.commentLine')<CR>")
vim.keymap.set("n", "<Leader>j", "*``cgn")

vim.keymap.set("n", "<Leader>fw", "<Cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>")
vim.keymap.set("n", "<Leader>ff", "<Cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")
vim.keymap.set("n", "<Leader>fb", "<Cmd>lua require('vscode').action('workbench.action.showAllEditors')<CR>")
vim.keymap.set("n", "<Leader><leader>", "<Cmd>lua require('vscode').action('workbench.action.showAllEditors')<CR>")

vim.keymap.set("n", "<Leader>lr", "<Cmd>lua require('vscode').action('editor.action.rename')<CR>")
vim.keymap.set("n", "<Leader>lR", "<Cmd>lua require('vscode').action('references-view.findReferences')<CR>")
vim.keymap.set("n", "<Leader>lf", "<Cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")
vim.keymap.set("n", "<Leader>ls", "<Cmd>lua require('vscode').action('workbench.action.gotoSymbol')<CR>")
vim.keymap.set("n", "<Leader>lG", "<Cmd>lua require('vscode').action('workbench.action.showAllSymbols')<CR>")

vim.keymap.set("n", "<Leader>db", "<Cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>")

vim.keymap.set("n", "<Leader>gg", "<Cmd>lua require('vscode').action('workbench.scm.focus')<CR>")

vim.keymap.set("n", "<Leader>e", "<Cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>")
vim.keymap.set("n", "<Leader>o", "<Cmd>lua require('vscode').action('workbench.files.action.focusFilesExplorer')<CR>")

