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

-- No one should be here.
vim.keymap.set("n", "Q", "<Nop>")
vim.keymap.set("v", "Q", "<Nop>")

-- Move up and down the highlighted lines.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor in place when appending lines.
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor in the middle when jumping.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Replace word under the cursor.
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

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
