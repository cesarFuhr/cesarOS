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
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

require 'treesitter-context'.setup {}
