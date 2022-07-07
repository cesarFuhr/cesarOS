-- Sets up theming settings.

require('material').setup({

  async_loading = true,

  contrast = {
    cursor_line = true,
  },

  borders = true, -- Enable borders between verticaly split windows

  popup_menu = "dark", -- Popup menu style ( can be: 'dark', 'light', 'colorful' or 'stealth' )

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
    TelescopePromptBorder  = { fg = "#616161" },
    TelescopeResultsBorder = { fg = "#616161" },
    TelescopePreviewBorder = { fg = "#616161" },
    TelescopeSelection     = { fg = "#82AAFF", bg = "#323232" },
    WinSeparator           = { fg = "#616161" },
  }, -- Overwrite highlights with your own
})

vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.g.material_style = 'darker'
vim.cmd([[ colorscheme material ]])
vim.cmd([[ syntax on ]])
