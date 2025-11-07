---@type LazySpec
return {
  "olimorris/codecompanion.nvim",
  opts = {
    display = {
      chat = {
        show_header_separator = true,
      },
    },
    strategies = {
      chat = {
        roles = {
          llm = function(adaptor)
            return "🤖 " .. adaptor.formatted_name
          end,
          user = "🧑 Me",
        },
      },
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true
        },
      },
    },
  },
  keys = {
    {
      "<leader>gcc",
      ":CodeCompanionChat<CR>",
      mode = { "n", "v" },
      desc = "CodeCompanion Chat",
      silent = true,
    },
    {
      "<leader>gcf",
      ":CodeCompanion<CR>",
      mode = { "n", "v" },
      desc = "CodeCompanion",
      silent = true,
    },
    {
      "<leader>gca",
      ":CodeCompanionActions<CR>",
      mode = { "n", "v" },
      desc = "CodeCompanion Actions",
      silent = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ravitemer/mcphub.nvim",
  },
}
