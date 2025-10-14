-- Sets up theming settings.

vim.g.material_style = 'darker'

local material = require 'material'
local colors = require 'material.colors'

local custom_colors = {
  bg     = "#202020",
  border = "#404040",
}

material.setup({
  async_loading = true,
  contrast = {
    non_current_windows = false,
    floating_windows = false,
  },
  disable = {
    colored_cursor = false, -- Disable the colored cursor
    borders = false,        -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
    background = true,      -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
    term_colors = false,    -- Prevent the theme from setting terminal colors
    eob_lines = false       -- Hide the end-of-buffer lines
  },
  custom_colors = function(clrs)
    clrs.editor.bg = custom_colors.bg
    clrs.editor.bg_num = custom_colors.bg
    clrs.editor.bg_sign = custom_colors.bg
    clrs.editor.border = custom_colors.border
  end,
  plugins = {
    "gitsigns",
    "nvim-cmp",
    "telescope",
    "nvim-web-devicons",
  },
  styles = {
    comments = { bold = true },
  },
  custom_highlights = {
    -- Brighter keywords
    TSKeyword               = { fg = custom_colors.cyan },

    TelescopePromptBorder   = { fg = custom_colors.border },
    TelescopeResultsBorder  = { fg = custom_colors.border },
    TelescopePreviewBorder  = { fg = custom_colors.border },
    TelescopeSelection      = { fg = colors.white },
    TelescopeSelectionCaret = { fg = colors.cyan, bg = custom_colors.bg },
    WinSeparator            = { fg = custom_colors.border },
  }, -- Overwrite highlights with your own
  lualine_style = 'stealth',
})


vim.opt.cursorline = true

vim.cmd 'syntax on'
vim.cmd 'colorscheme material'
