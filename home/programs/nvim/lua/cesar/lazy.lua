-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

return require 'lazy'.setup({
  spec = {
    { 'nvim-lua/plenary.nvim',                    lazy = false },
    { 'nvim-treesitter/nvim-treesitter',          lazy = false },
    { 'nvim-treesitter/playground' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'nvim-telescope/telescope.nvim',            lazy = false },
    -- faster fuzzy support for telescope.
    { 'nvim-telescope/telescope-fzf-native.nvim', lazy = false,                              build = 'make' },

    -- Better file manipulation.
    { "stevearc/oil.nvim" },

    -- UI.
    { 'stevearc/dressing.nvim' },
    { 'MunifTanjim/nui.nvim' },
    { 'kyazdani42/nvim-web-devicons' },
    { 'numToStr/FTerm.nvim' },
    { 'nvim-lualine/lualine.nvim',                lazy = false },
    { 'marko-cerovac/material.nvim',              lazy = false },

    -- Git integration.
    { 'lewis6991/gitsigns.nvim' },
    { 'awerebea/git-worktree.nvim',               branch = 'handle_changes_in_telescope_api' },
    { 'ThePrimeagen/harpoon' },

    { 'ardanlabs/ardango.nvim' },
    { 'hashivim/vim-terraform' },

    { 'L3MON4D3/LuaSnip' },
    { 'neovim/nvim-lspconfig' },
    { 'onsails/lspkind.nvim' },
    {
      'hrsh7th/cmp-nvim-lsp',
      dependencies = {
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/nvim-cmp',
        "hrsh7th/cmp-nvim-lsp-signature-help",
        -- for luasnip users.
        'saadparwaiz1/cmp_luasnip',
      },
    },
  },
})
