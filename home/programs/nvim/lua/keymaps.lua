local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local write = function()
  vim.api.nvim_command('write')
end
-- Fast write.
map('n', '<leader>w', write, opts)
-- Show invisible chars.
map('n', '<leader>lc', '<cmd>set invlist!<cr>', opts)

-- Quickfix
-- Go to quickfix window.
map('n', '<leader>ql', '<cmd>copen<cr>', opts)
-- Go to next quickfix.
map('n', '<leader>qk', '<cmd>cn<cr>', opts)
-- Go to prev quickfix.
map('n', '<leader>qj', '<cmd>cp<cr>', opts)

-- Toggle floating terminal.
local toggleTerm = require 'FTerm'.toggle
map({ 'n', 't' }, '<A-i>', toggleTerm, opts)

-- Telescope keymaps.
local telBuiltin = require 'telescope.builtin'
-- File fuzzy finder.
map('n', '<leader><leader>', telBuiltin.find_files, opts)
-- Open buffers fuzzy finder.
map('n', '<leader>fb', telBuiltin.buffers, opts)
-- Workspace live greping in all files.
map('n', '<leader>fg', telBuiltin.live_grep, opts)
-- Grep word under the cursor in current dir.
map('n', '<leader>fw', telBuiltin.grep_string, opts)
-- Live greping in the current buffer.
map('n', '<leader>fc', telBuiltin.current_buffer_fuzzy_find, opts)
-- Spell suggest to the word under the cursor.
map('n', '<leader>ss', telBuiltin.spell_suggest, opts)
-- Spell suggest to the word under the cursor.
map('n', '<leader>ch', telBuiltin.git_commits, opts)
-- Help tags.
map('n', '<leader>hh', telBuiltin.help_tags, opts)

-- Executes current file as lua script.
map('n', '<leader>lx', function()
  vim.cmd [[silent! write]]
  vim.cmd [[source %]]
end)
