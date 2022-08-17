-- Setting up a packer bootstrap function.
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

_ = vim.cmd [[packadd packer.nvim]]

return require 'packer'.startup(function(use)
  -- Adding packer to avoid it prompting to remove itself.
  use 'wbthomason/packer.nvim'

  use 'nvim-lua/plenary.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-telescope/telescope.nvim'
  -- faster fuzzy support for telescope.
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- better picker for nvim.
  use { 'stevearc/dressing.nvim' }
  use 'kyazdani42/nvim-web-devicons'
  use 'numToStr/FTerm.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'hashivim/vim-terraform'
  use 'fladson/vim-kitty'
  use 'marko-cerovac/material.nvim'

  -- Git integration.
  use 'airblade/vim-gitgutter'

  -- Lsp.
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind.nvim'

  -- Snippets.
  use 'L3MON4D3/LuaSnip'

  -- Completition.
  use {
    'hrsh7th/cmp-nvim-lsp',
    requires = {
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      "hrsh7th/cmp-nvim-lsp-signature-help",
      -- for luasnip users.
      'saadparwaiz1/cmp_luasnip',
    }
  }

  -- If bootstrapping, sync all packages before requiring them.
  if packer_bootstrap then
    require('packer').sync()
  end

  -- Setting up lualine.
  require('lualine').setup {
    options = {
      theme = 'onedark',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  }

  -- Setting up treesitter.
  require('nvim-treesitter.install').compilers = { "gcc" }
  require('nvim-treesitter.configs').setup {
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

end)
