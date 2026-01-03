local util = require "lspconfig.util"

local eslint_files = {
  ".eslintrc",
  ".eslintrc.*",
  "eslintrc",
  "eslintrc.*",
  "eslint.config.*",
}

local biome_files = { "biome.json" }

local oxlint_files = { ".oxlintrc.json" }

local deno_files = {
  "deno.json",
  "deno.jsonc",
  "deno.local.json", -- Git ignores this file in my environment. Just a flag to enable Deno LSP.
}

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      -- ---------------------------------------------------
      -- JavaScript / TypeScript
      -- ---------------------------------------------------
      vtsls = {
        on_new_config = function(config, _)
          local fname = vim.api.nvim_buf_get_name(0)
          if util.root_pattern(deno_files)(fname) then
            config.enabled = false
          else
            config.enabled = true
          end
        end,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            ["javascript.validate.enable"] = false,
            ["typescript.validate.enable"] = false,
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath "data"
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                },
              },
            },
          },
        },
      },
      volar = {
        on_init = function(client)
          local client_name = "vtsls"

          client.handlers["tsserver/request"] = function(_, result, context)
            local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = client_name }
            if #clients == 0 then
              vim.notify(
                "Could not found `" .. client_name .. "` lsp client, vue_lsp would not work without it.",
                vim.log.levels.ERROR
              )
              return
            end
            local ts_client = clients[1]

            local param = unpack(result)
            local id, command, payload = unpack(param)

            ts_client:exec_cmd({
              title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
              command = "typescript.tsserverRequest",
              arguments = {
                command,
                payload,
              },
            }, { bufnr = context.bufnr }, function(_, r)
              local response_data = { { id, r.body } }
              client:notify("tsserver/response", response_data)
            end)
          end
        end,
      },
      biome = {
        root_dir = util.root_pattern(biome_files),
      },
      eslint = {
        root_dir = util.root_pattern(eslint_files),
      },
      denols = {
        root_dir = util.root_pattern(deno_files),
      },
      oxlint = {
        root_dir = util.root_pattern(oxlint_files),
      },
      -- -- ---------------------------------------------------
      -- Python
      -- ---------------------------------------------------
      ruff = {
        on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      },
      ty = {
        cmd = { "ty", "server" },
        filetypes = { "python" },
        settings = {
          ty = {
            -- ty settings here
          },
        },
      },
      basedpyright = {
        settings = {
          basedpyright = {
            typeCheckingMode = "standard",
            analysis = {
              diagnosticSeverityOverrides = {
                reportUnusedExcept = false,
                -- ruff handles these
                reportUnusedVariable = false,
                reportUnusedImport = false,
              },
            },
          },
        },
      },
    },
    handlers = {
      ty = function(_, opts)
        vim.lsp.config("ty", opts)
        vim.lsp.enable "ty"
      end,
      basedpyright = false, -- disable basedpyright since I'm trying "ty" now!
    },
    servers = {
      "oxlint",
      "ty",
    },
    formatting = {
      disabled = {
        "volar",
        "biome", -- let None-LS biome format
      },
    },
  },
}

--[[

-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}

]]
