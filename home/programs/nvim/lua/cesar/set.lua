-- Setting preferences
local opt = vim.opt

-- Mouse support
opt.mouse = "a"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Signcolumn
opt.signcolumn = "yes"

-- File encoding
opt.fileencoding = "utf-8"

-- Split preferences
opt.splitbelow = true
opt.splitright = true

-- Tabs
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.copyindent = true

-- Line breaks
opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.linebreak = true

-- Reveal formatting chars
opt.listchars = [[tab:→\ ,space:·,nbsp:␣,trail:•,eol:$,precedes:«,extends:»]]

-- Custom shell, remove this if you use bash
-- or change it to whatever shell you use.
opt.shell = 'zsh'
