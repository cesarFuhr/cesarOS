-- Sets up theming settings.

vim.g.material_style = 'darker'
local colors = require('material.colors')
require('material').setup({

  async_loading = true,

  contrast = {
    cursor_line = true,
    popup_menu = true,
  },

  borders = true, -- Enable borders between verticaly split windows

  popup_menu = "dark", -- Popup menu style ( can be: 'dark', 'light', 'colorful' or 'stealth' )
  lualine_style = 'stealth',

  italics = {
    comments = false, -- Enable italic comments
    keywords = false, -- Enable italic keywords
    functions = true, -- Enable italic functions
    strings = false, -- Enable italic strings
    variables = false -- Enable italic variables
  },

  contrast_filetypes = {},

  text_contrast = {
    lighter = false, -- Enable higher contrast text for lighter style
    darker = false -- Enable higher contrast text for darker style
  },

  disable = {
    colored_cursor = false, -- Disable the colored cursor
    background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
    term_colors = false, -- Prevent the theme from setting terminal colors
    eob_lines = false -- Hide the end-of-buffer lines
  },

  custom_highlights = {
    --Normal = { bg = '#262626' },
    --NormalFloat = { bg = '#262626' },
    -- Brighter keywords
    TSKeyword = { fg = colors.cyan },

    TelescopePromptBorder  = { fg = colors.border },
    TelescopeResultsBorder = { fg = colors.border },
    TelescopePreviewBorder = { fg = colors.border },
    TelescopeSelection     = { fg = colors.white, bg = colors.bg_alt },
    WinSeparator           = { fg = colors.border },
  }, -- Overwrite highlights with your own
})

-- local grey = "#646568"
-- require 'onedark'.setup {
--   style = 'warm',
--   highlights = {
--     TelescopePromptBorder = { fg = grey },
--     TelescopeResultsBorder = { fg = grey },
--     TelescopePreviewBorder = { fg = grey },
--   },
--   diagnostics = {
--     warmer = true,
--   }
-- }
-- require 'onedark'.load()

vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.cmd 'syntax on'
vim.cmd 'colorscheme material'
