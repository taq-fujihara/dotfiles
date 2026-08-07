local function herdr_json(args, opts)
  opts = opts or {}
  local result = vim.system(args, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify((result.stderr or result.stdout or table.concat(args, " ") .. " failed"), vim.log.levels.ERROR)
    return nil
  end

  if result.stdout == nil or result.stdout == "" then
    if opts.allow_empty then return true end

    vim.notify("herdr output is empty", vim.log.levels.ERROR)
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, result.stdout)
  if not ok then
    vim.notify("Failed to parse herdr output", vim.log.levels.ERROR)
    return nil
  end

  return decoded
end

local function herdr_current_tab_id()
  local decoded = herdr_json { "herdr", "pane", "current", "--current" }
  return decoded and decoded.result and decoded.result.pane and decoded.result.pane.tab_id
end

local function herdr_agent_in_tab(tab_id)
  local decoded = herdr_json { "herdr", "agent", "list" }
  local agents = decoded and decoded.result and decoded.result.agents or {}

  for _, agent in ipairs(agents) do
    if agent.tab_id == tab_id then return agent end
  end

  return nil
end

local function herdr_current_pane()
  local decoded = herdr_json { "herdr", "pane", "current", "--current" }
  return decoded and decoded.result and decoded.result.pane
end

local function herdr_start_agent_left_of_current_pane()
  local current = herdr_current_pane()
  if current == nil or current.pane_id == nil or current.tab_id == nil then
    vim.notify("Herdr current pane not found", vim.log.levels.WARN)
    return nil
  end

  local cwd = vim.fn.getcwd()
  local agent_name = vim.fn.fnamemodify(cwd, ":t")
  if agent_name == "" then agent_name = "pi" end

  -- Herdr can split to the right/down. To create a left pane, create a right
  -- split, focus it, then swap it with the original pane.
  local split = herdr_json {
    "herdr",
    "pane",
    "split",
    current.pane_id,
    "--direction",
    "right",
    "--ratio",
    "0.28",
    "--cwd",
    cwd,
    "--focus",
  }
  local pane = split and split.result and split.result.pane
  if pane == nil or pane.pane_id == nil then
    vim.notify("Failed to create Herdr agent pane", vim.log.levels.WARN)
    return nil
  end

  herdr_json({ "herdr", "pane", "swap", "--pane", pane.pane_id, "--direction", "left" }, { allow_empty = true })

  local started = herdr_json { "herdr", "agent", "start", agent_name, "--kind", "pi", "--pane", pane.pane_id }
  if started == nil then return nil end

  local waited = herdr_json {
    "herdr",
    "agent",
    "wait",
    pane.pane_id,
    "--until",
    "idle",
    "--until",
    "done",
    "--until",
    "blocked",
    "--timeout",
    "30000",
  }
  if waited == nil then return nil end

  return herdr_agent_in_tab(current.tab_id)
end

local function herdr_agent_in_current_tab_or_start_left()
  local tab_id = herdr_current_tab_id()
  if tab_id == nil then
    vim.notify("Herdr current tab not found", vim.log.levels.WARN)
    return nil
  end

  return herdr_agent_in_tab(tab_id) or herdr_start_agent_left_of_current_pane()
end

local function current_range()
  local start_pos
  local end_pos

  if vim.fn.mode():match "^[vV\22]" then
    start_pos = vim.fn.getpos "v"
    local cursor = vim.api.nvim_win_get_cursor(0)
    end_pos = { 0, cursor[1], cursor[2] + 1, 0 }
  else
    local cursor = vim.api.nvim_win_get_cursor(0)
    start_pos = { 0, cursor[1], cursor[2] + 1, 0 }
    end_pos = start_pos
  end

  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  return start_line, start_col, end_line, end_col
end

local function herdr_send_text_and_focus_agent(agent, text)
  if herdr_json({ "herdr", "pane", "send-text", agent.pane_id, text }, { allow_empty = true }) == nil then return end

  herdr_json { "herdr", "agent", "focus", agent.pane_id }
end

return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = false,
      },
      win = {
        layout = "left",
        split = {
          width = 60,
        },
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>a",
      desc = "Sidekick",
    },
    {
      "<leader>aa",
      function()
        if vim.env.HERDR_ENV == nil then
          require("sidekick.cli").toggle()
          return
        end

        local agent = herdr_agent_in_current_tab_or_start_left()
        if agent == nil then return end

        herdr_json { "herdr", "agent", "focus", agent.pane_id }
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        if vim.env.HERDR_ENV == nil then
          require("sidekick.cli").send { msg = "{this}" }
          return
        end

        local agent = herdr_agent_in_current_tab_or_start_left()
        if agent == nil then return end

        local path = vim.api.nvim_buf_get_name(0)
        if path == "" then
          vim.notify("Current buffer has no name", vim.log.levels.WARN)
          return
        end

        local start_line, start_col, end_line, end_col = current_range()

        path = vim.fn.fnamemodify(path, ":.")
        local text = string.format("@%s :L%d:C%d-L%d:C%d ", path, start_line, start_col, end_line, end_col)
        herdr_send_text_and_focus_agent(agent, text)
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        if vim.env.HERDR_ENV == nil then
          require("sidekick.cli").send { msg = "{file}" }
          return
        end

        local agent = herdr_agent_in_current_tab_or_start_left()
        if agent == nil then return end

        local path = vim.api.nvim_buf_get_name(0)
        if path == "" then
          vim.notify("Current buffer has no name", vim.log.levels.WARN)
          return
        end

        path = vim.fn.fnamemodify(path, ":.")
        local text = "@" .. path .. " "
        herdr_send_text_and_focus_agent(agent, text)
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send { msg = "{selection}" } end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle { name = "copilot", focus = true } end,
      desc = "Sidekick Toggle Copilot",
    },
  },
}
