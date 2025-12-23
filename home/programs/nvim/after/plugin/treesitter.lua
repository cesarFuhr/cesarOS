-- Setting up treesitter.
require 'nvim-treesitter.install'.compilers = { "gcc" }
require 'nvim-treesitter.configs'.setup {
  playground = { enable = true },
  ensure_installed = {
    "make",
    "markdown",
    "bash",
    "c",
    "lua",
    "rust",
    "nix",
    "go",
    "gomod",
    "graphql",
    "json",
    "yaml",
    "html",
    "proto",
    "javascript",
    "typescript",
    "tsx",
    "dockerfile",
    "python",
    "helm",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

require 'treesitter-context'.setup {
  enable = true,
  max_lines = 4,
}

vim.filetype.add({
  extension = {
    yaml = 'helm',
    yml = 'helm',
  },
})
