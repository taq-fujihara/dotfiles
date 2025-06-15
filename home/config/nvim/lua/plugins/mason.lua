---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        "codelldb",
        "debugpy",
        "deno",
        "eslint-lsp",
        "jdtls",
        "java-debug-adapter",
        "js-debug-adapter",
        "lua-language-server",
        "ruff",
        "rust-analyzer",
        "terraform-ls",
        "typescript-language-server",
      },
    },
  },
}
