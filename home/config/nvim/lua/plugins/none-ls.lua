local null_ls = require "null-ls"

local function has_prettier_config(utils)
  return utils.has_file(
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    "prettier.config.js",
    ".prettierrc.mjs",
    "prettier.config.mjs",
    "prettier.config.cjs",
    ".prettierrc.toml"
  )
end

local function has_deno_config(utils)
  return utils.has_file(
    "deno.json",
    "deno.jsonc",
    "deno.local.json" -- git ignores this file in my environment. just a flag to enable deno lsp.
  )
end

---@type LazySpec
return {
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        -- ---------------------------------------------------
        -- JavaScript / TypeScript
        -- ---------------------------------------------------
        null_ls.builtins.formatting.prettier.with {
          condition = function(utils) return has_prettier_config(utils) end,
        },
        -- Default
        null_ls.builtins.formatting.biome.with {
          condition = function(utils)
            if has_prettier_config(utils) then return false end
            if has_deno_config(utils) then return false end

            return true
          end,
        },

        -- ---------------------------------------------------
        -- Lua
        -- ---------------------------------------------------
        null_ls.builtins.formatting.stylua,

        -- ---------------------------------------------------
        -- Docker
        -- ---------------------------------------------------
        null_ls.builtins.diagnostics.hadolint,

        -- ---------------------------------------------------
        -- Markdown
        -- ---------------------------------------------------
        null_ls.builtins.diagnostics.markdownlint_cli2,
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = {
      handlers = {
        -- disable all automatic registration
        -- (had problem biome formatter always attached...)
        function() end,
      },
    },
  },
}

--[[

-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    -- local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

    -- Only insert new sources, do not replace the existing ones
    -- (If you wish to replace, use `opts.sources = {}` instead of the `list_insert_unique` function)
    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- Set a formatter
      -- null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.prettier,
    })
  end,
}

]]
