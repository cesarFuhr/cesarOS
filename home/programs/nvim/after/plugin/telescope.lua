local t = require 'telescope'

t.setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

t.load_extension('fzf')
t.load_extension('git_worktree')
t.load_extension('harpoon')

local opts = { noremap = true, silent = true }

-- Telescope keymaps.
local telBuiltin = require 'telescope.builtin'
-- File fuzzy finder.
vim.keymap.set('n', '<leader>ff', telBuiltin.find_files, opts)
-- Open buffers fuzzy finder.
vim.keymap.set('n', '<leader><leader>', telBuiltin.buffers, opts)
-- Workspace live greping in all files.
vim.keymap.set('n', '<leader>fg', telBuiltin.live_grep, opts)
-- Grep word under the cursor in current dir.
vim.keymap.set('n', '<leader>fw', telBuiltin.grep_string, opts)
-- Live greping in the current buffer.
vim.keymap.set('n', '<leader>fc', telBuiltin.current_buffer_fuzzy_find, opts)
-- Spell suggest to the word under the cursor.
vim.keymap.set('n', '<leader>ss', telBuiltin.spell_suggest, opts)
-- List current repo commits.
vim.keymap.set('n', '<leader>ch', telBuiltin.git_commits, opts)
-- Help tags.
vim.keymap.set('n', '<leader>hh', telBuiltin.help_tags, opts)

-- Telescope maps.
local git_worktree = require 'telescope'.extensions.git_worktree
local harpoon = require 'telescope'.extensions.harpoon

-- Git Worktrees
vim.keymap.set('n', '<leader>st', git_worktree.git_worktree, opts)
vim.keymap.set('n', '<leader>ct', git_worktree.create_git_worktree, opts)

-- Harpoon
vim.keymap.set('n', '<leader>ms', harpoon.marks)
