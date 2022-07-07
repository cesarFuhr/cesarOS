-- Set leader
-- It is important to set it up before everything
-- plugins will set up mappings based on it.
vim.g.mapleader = ' '

-- settings store all the vim settings.
require('settings')

-- plugins sets up all plugins using packer.
require('plugins')

-- keymaps is were you should all your general keymaps.
require('keymaps')

-- telescope setups telescope.
require('telescope')

-- snip sets up snipets and snipet engine.
require('snip')

-- lsp sets up native lsp support and lsp keymaps.
require('lsp')

-- theme has all the theming setup.
require('theme')
