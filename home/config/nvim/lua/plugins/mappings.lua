local function split_right()
  vim.cmd "vsplit"
  vim.cmd "wincmd l"
  require("snacks").picker.files()
end

local function split_left()
  vim.cmd "vsplit"
  vim.cmd "wincmd h"
  require("snacks").picker.files()
end

local function split_down()
  vim.cmd "split"
  vim.cmd "wincmd j"
  require("snacks").picker.files()
end

local function split_up()
  vim.cmd "split"
  vim.cmd "wincmd k"
  require("snacks").picker.files()
end

local function exec_pane_move(direction)
  if vim.bo.buftype == "terminal" then vim.cmd "stopinsert" end

  local has_more_window = vim.fn.winnr() ~= vim.fn.winnr(direction)

  if has_more_window then
    -- usual nvim window movement
    vim.cmd("wincmd " .. direction)
  else
    -- move wezterm pane in the direction via wezterm cli
    local directions = { h = "Left", j = "Down", k = "Up", l = "Right" }
    -- TODO: might need to change "wezterm" executable name for other platforms
    local command = { "wezterm", "cli", "activate-pane-direction", directions[direction] }

    vim.system(command)
  end
end

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          [";"] = { ":", desc = "CMD enter command mode" },

          ["<Leader>y"] = { '"+y', desc = "Copy to system clipboard" },
          ["<Leader>pa"] = false,
          ["<Leader>pi"] = false,
          ["<Leader>pm"] = false,
          ["<Leader>pM"] = false,
          ["<Leader>ps"] = false,
          ["<Leader>pS"] = false,
          ["<Leader>pu"] = false,
          ["<Leader>pU"] = false,

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

          ["<C-h>"] = { function() exec_pane_move "h" end },
          ["<C-j>"] = { function() exec_pane_move "j" end },
          ["<C-k>"] = { function() exec_pane_move "k" end },
          ["<C-l>"] = { function() exec_pane_move "l" end },

          ["<Leader>bo"] = { desc = "Open File by Search" },
          ["<Leader>boh"] = { split_left, desc = "Split Left" },
          ["<Leader>boj"] = { split_down, desc = "Split Down" },
          ["<Leader>bok"] = { split_up, desc = "Split Up" },
          ["<Leader>bol"] = { split_right, desc = "Split Right" },

          ["<Leader>="] = {
            function() vim.cmd "wincmd =" end,
            desc = "Equalize splits",
          },

          ["<Leader>j"] = {
            "*``cgn",
            desc = "Replace Word under Cursor",
          },

          ["<Leader><Leader>"] = {
            function() require("snacks").picker.smart() end,
            desc = "Find buffers",
          },
          ["<Leader>c"] = {
            function()
              local bufs = vim.fn.getbufinfo { buflisted = true }
              require("astrocore.buffer").close(0)
              if not bufs[2] then require("snacks").dashboard() end
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

          ["<Leader>y"] = { '"+y', desc = "Copy to system clipboard" },

          ["<Leader>ll"] = {
            function()
              local fn = vim.api.nvim_buf_get_name(0)
              local ft = vim.bo.filetype

              for i in string.gmatch(fn, "[^/]+") do
                fn = i
              end

              local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

              if ft == "javascript" or ft == "typescript" then
                vim.api.nvim_feedkeys(
                  'mzyoconsole.log("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa);" .. esc .. "`z",
                  "n",
                  true
                )
              elseif ft == "python" then
                vim.api.nvim_feedkeys(
                  'mzyoprint("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa)" .. esc .. "`z",
                  "n",
                  true
                )
              else
                print('🚀 TurboStdout -> Filetype: "' .. ft .. '" is not supported')
              end
            end,
            desc = "Turbo Stdout",
          },
        },
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
                vim.api.nvim_feedkeys(
                  'mzviWyoconsole.log("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa);" .. esc .. "`z",
                  "n",
                  true
                )
              elseif ft == "python" then
                vim.api.nvim_feedkeys(
                  'mzviWyoprint("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa)" .. esc .. "`z",
                  "n",
                  true
                )
              else
                print('🚀 TurboStdout -> Filetype: "' .. ft .. '" is not supported')
              end
            end,
            desc = "Turbo Stdout",
          },
        },
      },
    },
  },
}
