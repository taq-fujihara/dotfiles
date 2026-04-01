---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        "biome",
        "codelldb",
        "debugpy",
        "deno",
        "docker-language-server",
        "eslint-lsp",
        "jdtls",
        "java-debug-adapter",
        "js-debug-adapter",
        "lua-language-server",
        "markdownlint-cli2",
        "markdown-oxide",
        "oxfmt",
        "oxlint",
        "ruff",
        "rust-analyzer",
        "stylua",
        "svelte-language-server",
        "terraform-ls",
        "ty",
        "vue-language-server",
        "vtsls",
      },
    },
  },
}

--[[

-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}

]]
