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

return require 'packer'.startup(function(use)
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
  use 'navarasu/onedark.nvim'

  use 'ardanlabs/ardango.nvim'

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

  -- If bootstrapping, sync all packages before requiring them.
  if packer_bootstrap then
    require 'packer'.sync()
  end

  require 'FTerm'.setup {
    border = 'rounded'
  }

  -- Setting up lualine.
  require 'lualine'.setup {
    options = {
      theme = 'material',
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

  require('gitsigns').setup {
    signs = {
      add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      delete       = { hl = 'GitSignsDelete', text = '│', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or { silent = true }
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
    end
  }

end)
