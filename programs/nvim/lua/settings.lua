-- Setting preferences
local opt = vim.opt

-- Mouse support
opt.mouse = 'a'

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Signcolumn
opt.signcolumn = 'yes'

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

-- Blinky cursor
-- opt.gcr = [[n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait1000-blinkoff400-blinkon250-Cursor/lCursor]]

-- Custom shell, remove this if you use bash
-- or change it to whatever shell you use.
opt.shell = 'zsh'

-- GitGutter
vim.g.gitgutter_preview_win_floating = 0
