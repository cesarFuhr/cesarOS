local zen = require 'zen-mode'


local opts = { noremap = true, silent = true }

local toggle = function()
  zen.toggle {
    window = {
      width = .6, -- width of the Zen window
      height = 1, -- height of the Zen window
    },
    plugins = {
      kitty = {
        enabled = true,
        font = "+1", -- font size increment
      },
    },
  }
end


-- Toggle zen mode.
vim.keymap.set('n', '<leader>zm', toggle, opts)
