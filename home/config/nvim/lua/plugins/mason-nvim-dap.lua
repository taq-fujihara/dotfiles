return {
  "jay-babu/mason-nvim-dap.nvim",
  opts = {
    handlers = {
      function(config)
        local dap = require "dap"

        if not dap.adapters["pwa-node"] then
          dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = { command = vim.fn.exepath "js-debug-adapter", args = { "${port}" } },
          }
        end
        if not dap.adapters.node then
          dap.adapters.node = function(cb, config)
            if config.type == "node" then config.type = "pwa-node" end
            local pwa_adapter = dap.adapters["pwa-node"]
            if type(pwa_adapter) == "function" then
              pwa_adapter(cb, config)
            else
              cb(pwa_adapter)
            end
          end
        end

        local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
        local js_config = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = "Launch file (Deno)",
            runtimeExecutable = "deno",
            runtimeArgs = {
              "run",
              "--inspect-wait",
              "--allow-all"
            },
            program = "${file}",
            cwd = "${workspaceFolder}",
            attachSimplePort = 9229,
          },
        }

        for _, language in ipairs(js_filetypes) do
          if not dap.configurations[language] then dap.configurations[language] = js_config end
        end

        local vscode_filetypes = require("dap.ext.vscode").type_to_filetypes
        vscode_filetypes["node"] = js_filetypes
        vscode_filetypes["pwa-node"] = js_filetypes

        require('mason-nvim-dap').default_setup(config)
      end,
      codelldb = function(config)
        local dap = require("dap")

        dap.adapters.codelldb = {
          type = "executable",
          command = "codelldb",
        }

        dap.configurations.rust = {
          {
            name = "Launch file (Executable)",
            type = "codelldb",
            request = "launch",
            program = '${workspaceFolder}/target/debug/${workspaceFolderBasename}',
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
          },
          {
            name = "Launch file (Select executable)",
            type = "codelldb",
            request = "launch",
            program = function()
              local abs_path = vim.fn.getcwd()
              local basename = string.gsub(abs_path, "(.*/)(.*)", "%2")

              return vim.fn.input(
                'Path to executable: ',
                abs_path .. '/target/debug/' .. basename,
                'file'
              )
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
          },
        }

        require('mason-nvim-dap').default_setup(config)
      end,
    },
  },
}
