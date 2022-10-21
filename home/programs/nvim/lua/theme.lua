-- Sets up theming settings.

vim.g.material_style = 'darker'

local custom_colors = vim.tbl_deep_extend("force", require('material.colors'), {
  bg     = "#262626",
  border = "#404040",
})

require('material').setup({

  async_loading = true,

  contrast = {
    popup_menu = true,
  },

  disable = {
    colored_cursor = false, -- Disable the colored cursor
    borders = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
    background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
    term_colors = false, -- Prevent the theme from setting terminal colors
    eob_lines = false -- Hide the end-of-buffer lines
  },

  custom_colors = function(colors)
    colors.editor.bg = custom_colors.bg
    colors.editor.bg_num = custom_colors.bg
    colors.editor.bg_sign = custom_colors.bg
    colors.editor.border = custom_colors.border
  end,

  plugins = {
    "gitsigns",
    "nvim-cmp",
    "telescope",
  },

  custom_highlights = {
    -- Brighter keywords
    TSKeyword = { fg = custom_colors.cyan },

    TelescopePromptBorder   = { fg = custom_colors.border },
    TelescopeResultsBorder  = { fg = custom_colors.border },
    TelescopePreviewBorder  = { fg = custom_colors.border },
    TelescopeSelection      = { fg = custom_colors.white },
    TelescopeSelectionCaret = { fg = custom_colors.cyan, bg = custom_colors.bg },
    WinSeparator            = { fg = custom_colors.border },
  }, -- Overwrite highlights with your own

  lualine_style = 'stealth',
})


vim.opt.cursorline = true

vim.cmd 'syntax on'
vim.cmd 'colorscheme material'
