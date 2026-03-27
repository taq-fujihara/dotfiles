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

local function get_filename()
  local fn = vim.api.nvim_buf_get_name(0)

  for i in string.gmatch(fn, "[^/]+") do
    fn = i
  end

  return fn
end

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          [";"] = { ":", desc = "CMD enter command mode" },
          -- Yank
          ["<Leader>y"] = { '"+y', desc = "Copy to system clipboard" },
          ["<Leader>pa"] = false, -- want to disable all the keys under p ("packages" by AstroNvim) to use for my own mappings (Yanky). TODO: find a better way to disable all the keys under p instead of disabling them one by one
          ["<Leader>pi"] = false,
          ["<Leader>pm"] = false,
          ["<Leader>pM"] = false,
          ["<Leader>ps"] = false,
          ["<Leader>pS"] = false,
          ["<Leader>pu"] = false,
          ["<Leader>pU"] = false,
          -- Buffer Navigation
          L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          ["<Leader>c"] = {
            function()
              local bufs = vim.fn.getbufinfo { buflisted = true }
              require("astrocore.buffer").close(0)
              if not bufs[2] then require("snacks").dashboard() end
            end,
            desc = "Close buffer",
          },
          -- Centered Scrolling
          ["<C-u>"] = { "<C-u>zz" },
          ["<C-d>"] = { "<C-d>zz" },
          -- Window Splits
          ["-"] = {
            "<cmd>split<cr>",
            desc = "Horizontal Split",
          },
          ["<Leader>bo"] = { desc = "Open File by Search" },
          ["<Leader>boh"] = { split_left, desc = "Split Left" },
          ["<Leader>boj"] = { split_down, desc = "Split Down" },
          ["<Leader>bok"] = { split_up, desc = "Split Up" },
          ["<Leader>bol"] = { split_right, desc = "Split Right" },
          ["<Leader>="] = {
            function() vim.cmd "wincmd =" end,
            desc = "Equalize splits",
          },
          -- Pane Movement (Move between nvim windows and wezterm panes seamlessly)
          ["<C-h>"] = { function() exec_pane_move "h" end, desc = "Move Left" },
          ["<C-j>"] = { function() exec_pane_move "j" end, desc = "Move Down" },
          ["<C-k>"] = { function() exec_pane_move "k" end, desc = "Move Up" },
          ["<C-l>"] = { function() exec_pane_move "l" end, desc = "Move Right" },
          -- Find
          ["<Leader><Leader>"] = {
            function() require("snacks").picker.smart() end,
            desc = "Find buffers",
          },
          -- Editing
          ["<C-_>"] = {
            function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
            desc = "Comment Line",
          },
          ["<Leader>j"] = {
            "*``cgn",
            desc = "Replace Word under Cursor",
          },
          ["<Leader>ll"] = {
            function()
              local fn = get_filename()
              local ft = vim.bo.filetype

              local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

              if ft == "javascript" or ft == "typescript" then
                vim.api.nvim_feedkeys(
                  'mbviwyoconsole.log("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa);" .. esc .. "`b",
                  "n",
                  true
                )
              elseif ft == "python" then
                vim.api.nvim_feedkeys(
                  'mbviwyoprint("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa)" .. esc .. "`b",
                  "n",
                  true
                )
              else
                vim.notify('🚀 TurboStdout -> Filetype: "' .. ft .. '" is not supported')
              end
            end,
            desc = "Turbo Stdout",
          },
          -- Misc
          ["<Leader>m"] = { desc = " Markdown" },
        },
        i = {},
        v = {
          [";"] = { ":", desc = "CMD enter command mode" },
          -- Yank
          ["<Leader>y"] = { '"+y', desc = "Copy to system clipboard" },
          -- Editing
          ["<Leader>ll"] = {
            function()
              local fn = get_filename()
              local ft = vim.bo.filetype

              local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

              if ft == "javascript" or ft == "typescript" then
                vim.api.nvim_feedkeys(
                  'mbyoconsole.log("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa);" .. esc .. "`b",
                  "n",
                  true
                )
              elseif ft == "python" then
                vim.api.nvim_feedkeys(
                  'mbyoprint("🚀 ~ ' .. fn .. " ~ " .. esc .. 'pa:", ' .. esc .. "pa)" .. esc .. "`b",
                  "n",
                  true
                )
              else
                vim.notify('🚀 TurboStdout -> Filetype: "' .. ft .. '" is not supported')
              end
            end,
            desc = "Turbo Stdout",
          },
        },
      },
    },
  },
}
