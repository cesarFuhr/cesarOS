require 'FTerm'.setup {
  border = 'rounded',
  dimensions = {
    height = 0.95,
    width = 0.95,
  },
}

local opts = { noremap = true, silent = true }

-- Toggle floating terminal.
local toggleTerm = require 'FTerm'.toggle
vim.keymap.set({ 'n', 't' }, '<A-i>', toggleTerm, opts)
