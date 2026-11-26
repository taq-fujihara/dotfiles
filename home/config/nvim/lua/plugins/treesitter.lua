---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true, -- enable/disable treesitter based highlighting
      indent = true, -- enable/disable treesitter based indentation
      auto_install = true, -- enable/disable automatic installation of detected languages
      ensure_installed = {
        "astro",
        "css",
        "dockerfile",
        "html",
        "java",
        "javascript",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "scss",
        "sql",
        "svelte",
        "toml",
        "typescript",
        "vue",
        "vim",
      },
    },
  },
}
