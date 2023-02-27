-- Setting up a packer bootstrap function.
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

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

_ = vim.cmd 'packadd packer.nvim'
local packer = require 'packer'

return packer.startup(function(use)
      -- Adding packer to avoid it prompting to remove itself.
      use 'wbthomason/packer.nvim'

      use 'nvim-lua/plenary.nvim'
      use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
      use 'nvim-treesitter/playground'
      use 'nvim-treesitter/nvim-treesitter-context'
      use 'nvim-telescope/telescope.nvim'
      -- faster fuzzy support for telescope.
      use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      -- better picker for nvim.
      use { 'stevearc/dressing.nvim' }
      use { 'MunifTanjim/nui.nvim' }
      use 'kyazdani42/nvim-web-devicons'
      use 'numToStr/FTerm.nvim'
      use 'nvim-lualine/lualine.nvim'
      use 'hashivim/vim-terraform'
      use 'fladson/vim-kitty'
      use 'marko-cerovac/material.nvim'

      use 'ardanlabs/ardango.nvim'

      -- Focus mode.
      use("folke/zen-mode.nvim")

      -- Undo tree.
      use('mbbill/undotree')

      -- Git integration.
      use 'ThePrimeagen/git-worktree.nvim'
      use 'lewis6991/gitsigns.nvim'

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

      -- If bootstrapping, sync all packages.
      if packer_bootstrap then
        packer.sync()
      end
    end)
