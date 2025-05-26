return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          [";"] = { ":", desc = "CMD enter command mode" },

          ["<Left>"] = { "<Cmd>vertical resize +4<CR>", desc = "Resize split left" },
          ["<Up>"] = { "<Cmd>resize -2<CR>", desc = "Resize split up" },
          ["<Down>"] = { "<Cmd>resize +2<CR>", desc = "Resize split down" },
          ["<Right>"] = { "<Cmd>vertical resize -4<CR>", desc = "Resize split right" },

          L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

          ["<C-u>"] = { "<C-u>zz" },
          ["<C-d>"] = { "<C-d>zz" },

          ["-"] = {
            "<cmd>split<cr>",
            desc = "Horizontal Split",
          },
          ["<C-_>"] = {
            function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
            desc = "Comment Line",
          },

          ["<Leader>j"] = {
            "*``cgn",
            desc = "Replace Word under Cursor",
          },
          ["<Leader><Leader>"] = {
            function() require("snacks").picker.smart() end, desc = "Find buffers",
          },
          ["<Leader>c"] = {
            function()
              local bufs = vim.fn.getbufinfo({ buflisted = true })
              require("astrocore.buffer").close(0)
              if not bufs[2] then
                require("snacks").dashboard()
              end
            end,
            desc = "Close buffer",
          },
          ["<Leader>a"] = {
            "ggVG",
            desc = "Select All",
          },
          ["<Leader>m"] = { desc = " Markdown" },
        },
        i = {
          ["<C-_>"] = {
            function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
            desc = "Comment Line",
          },
        },
        v = {
          [";"] = { ":", desc = "CMD enter command mode" },
          ["<Leader>ll"] = {
            function()
              local fn = vim.api.nvim_buf_get_name(0)
              local ft = vim.bo.filetype

              for i in string.gmatch(fn, "[^/]+") do
                fn = i
              end

              local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

              if ft == "javascript" or ft == "typescript" then
                vim.api.nvim_feedkeys("mzyoconsole.log(\"🚀 ~ " .. fn .. " ~ " .. esc .. "pa:\", " .. esc .. "pa);" .. esc .. "`z", "n", true)
              elseif ft == 'python' then
                vim.api.nvim_feedkeys("mzyoprint(\"🚀 ~ " .. fn .. " ~ " .. esc .. "pa:\", " .. esc .. "pa)" .. esc .. "`z", "n", true)
              else
                print("🚀 TurboStdout -> Filetype: \"" .. ft .. "\" is not supported")
              end
            end,
            desc = "Turbo Stdout"
          },
        }
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>ll"] = {
            function()
              local fn = vim.api.nvim_buf_get_name(0)
              local ft = vim.bo.filetype

              for i in string.gmatch(fn, "[^/]+") do
                fn = i
              end

              local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

              if ft == "javascript" or ft == "typescript" then
                vim.api.nvim_feedkeys("mzviWyoconsole.log(\"🚀 ~ " .. fn .. " ~ " .. esc .. "pa:\", " .. esc .. "pa);" .. esc .. "`z", "n", true)
              elseif ft == 'python' then
                vim.api.nvim_feedkeys("mzviWyoprint(\"🚀 ~ " .. fn .. " ~ " .. esc .. "pa:\", " .. esc .. "pa)" .. esc .. "`z", "n", true)
              else
                print("🚀 TurboStdout -> Filetype: \"" .. ft .. "\" is not supported")
              end
            end,
            desc = "Turbo Stdout"
          },
        },
      },
    },
  },
}
