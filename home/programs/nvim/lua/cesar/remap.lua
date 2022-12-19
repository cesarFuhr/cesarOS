-- Set leader
-- It is important to set it up before everything
-- plugins will set up mappings based on it.
vim.g.mapleader = ' '

local opts = { noremap = true, silent = true }

local write = function()
  vim.api.nvim_command('write')
end
-- Fast write.
vim.keymap.set('n', '<leader>w', write, opts)
-- Show invisible chars.
vim.keymap.set('n', '<leader>lc', '<cmd>set invlist!<cr>', opts)
-- Special paste.
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Special delete.
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
-- Yank into clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Quickfix
-- Go to quickfix window.
vim.keymap.set('n', '<leader>ql', '<cmd>copen<cr>', opts)
-- Go to next quickfix.
vim.keymap.set('n', '<leader>qk', '<cmd>cn<cr>', opts)
-- Go to prev quickfix.
vim.keymap.set('n', '<leader>qj', '<cmd>cp<cr>', opts)

-- Executes current file as lua script.
vim.keymap.set('n', '<leader>lx', function()
  vim.cmd [[silent! write]]
  vim.cmd [[source %]]
end)
