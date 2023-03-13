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
    "org",
  },
  highlight = {
    enable = true,
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = { 'org' },
  },
  indent = {
    enable = true,
  },
}

require 'treesitter-context'.setup {}
