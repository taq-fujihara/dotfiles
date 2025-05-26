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
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"

    opts.sources = require("astrocore").list_insert_unique(opts.sources, {
      -- ---------------------------------------------------
      -- JavaScript / TypeScript
      -- ---------------------------------------------------
      -- Use Prettier only when prettier config is present 
      null_ls.builtins.formatting.prettier.with {
        condition = has_prettier_config,
        -- only_local = true,
      },
      -- Default Biome
      null_ls.builtins.formatting.biome.with {
        condition = function(utils)
          local has_prettier = has_prettier_config(utils)
          local has_deno = has_deno_config(utils)
          return not (has_prettier or has_deno)
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
    })
  end,
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
