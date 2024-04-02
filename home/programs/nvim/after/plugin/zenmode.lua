local zen = require 'zen-mode'


local opts = { noremap = true, silent = true }

local toggle = function()
  zen.toggle {
    window = {
      width = .6, -- width of the Zen window
      height = 1, -- height of the Zen window
    },
  }
end


-- Toggle zen mode.
vim.keymap.set('n', '<leader>zm', toggle, opts)
