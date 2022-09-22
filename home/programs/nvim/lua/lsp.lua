local cmp     = require 'cmp'
local lspkind = require 'lspkind'

-- cmp is the completition engine.
cmp.setup({
  snippet = {
    expand = function(args)
      -- here we link the snippet engine with cmp.
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    -- Control + K to navigate down in the suggestions list.
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    -- Control + K to navigate up in the suggestions list.
    ['<C-j>'] = cmp.mapping.select_next_item(),
    -- Control + d to scroll down inside the docs of the suggestion.
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-3), { 'i', 'c' }),
    -- Control + d to scroll up inside the docs of the suggestion.
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(3), { 'i', 'c' }),
    -- Control + space to invoque the autocompletion menu.
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    -- Control + e to close the suggestion menu/window.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Return to confirm the selected suggestion.
    ['<Return>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  -- cmp is a completition engine and it can be configured
  -- to receive suggestions from many sources.
  -- here I have: lsp, snippets, path and buffer.
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = "nvim_lsp_signature_help" },
  }, {
    -- completition buffer is only activated after the 5th char.
    { name = 'buffer', keyword_length = 5, max_item_count = 10 },
  }),
  view = {
    entries = "custom"
  },
  formatting = {
    -- this sets the completition tags that show the source of the suggestion.
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        luasnip = "[snip]",
      },
    },
  },
  -- this is a nice feature that creates virtual text with
  -- with the top suggestion.
  experimental = {
    ghost_text = true,
  },
})

-- Setup lspconfig.
-- Warns the lsp that it can suggest snippets.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lspconfig = require 'lspconfig'
local telescopeBuiltin = require 'telescope.builtin'

-- Sets a function that will be called when a buffer with a supported
-- language is opened. This is how we configure the keybindings to lsp
-- when the language is supported, but left the keybindings as the default
-- otherwise.
local custom_lsp_attach = function()
  local map = vim.keymap.set
  -- Shows help on hover.
  map('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
  -- Jumps to definition.
  map('n', 'gd', telescopeBuiltin.lsp_definitions, { buffer = 0 })
  -- Jumps to declaration.
  map('n', 'gD', vim.lsp.buf.declaration, { buffer = 0 })
  -- Jumps to type definition.
  map('n', 'gt', telescopeBuiltin.lsp_type_definitions, { buffer = 0 })
  -- Lists or jumps to interface implementation.
  map('n', 'gi', telescopeBuiltin.lsp_implementations, { buffer = 0 })
  -- Lists all the buffer symbols.
  map('n', 'gb', telescopeBuiltin.lsp_document_symbols, { buffer = 0 })
  -- Lists all the workspace symbols.
  map('n', 'gw', telescopeBuiltin.lsp_dynamic_workspace_symbols, { buffer = 0 })
  -- Lists all the references to the symbols under the cursor.
  map('n', 'gr', telescopeBuiltin.lsp_references, { buffer = 0 })
  -- Applies formatting to the buffer.
  map('n', '<leader>f', vim.lsp.buf.formatting, { buffer = 0 })
  -- Opens the diagnostic as a floating window.
  map('n', '<leader>de', vim.diagnostic.open_float, { buffer = 0 })
  -- Lists diagnostics in quickfix.
  map('n', '<leader>dq', vim.diagnostic.setloclist, { buffer = 0 })
  -- Jump to the next diagnostic.
  map('n', '<leader>dj', vim.diagnostic.goto_next, { buffer = 0 })
  -- Jump to the previous diagnostic.
  map('n', '<leader>dk', vim.diagnostic.goto_prev, { buffer = 0 })
  -- Lists all diagnostics on telescope.
  map('n', '<leader>dl', telescopeBuiltin.diagnostics, { buffer = 0 })
  -- Lists code actions on telescope.
  map('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = 0 })
  -- Renames the symbol under the cursor. Does not saves all buffers that were changes.
  map('n', '<leader>rn', vim.lsp.buf.rename, { buffer = 0 })
end

-- Go!
-- TODO:
-- - Run tests as a command
-- - Build package as command
lspconfig.gopls.setup {
  -- warns the LSP that it can send snippets suggestions.
  capabilities = capabilities,
  -- sets up lsp keybindings.
  on_attach = custom_lsp_attach,
  -- gopls settings.
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    }
  }
}
-- Formats the file on save.
vim.api.nvim_command('autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting_sync()')

local ardango = require("ardango")
local go_augroup = vim.api.nvim_create_augroup("go_utils", { clear = true })

-- Update imports on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = go_augroup,
  pattern = "*.go",
  callback = function() ardango.OrgBufImports(1000) end,
})

-- Rust
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importMergeBehavior = "last",
        importPrefix = "by_self",
      },
      diagnostics = {
        disabled = { "unresolved-import" }
      },
      cargo = {
        loadOutDirsFromCheck = true
      },
      procMacro = {
        enable = true
      },
      checkOnSave = {
        command = "clippy"
      },
    }
  }
}
vim.api.nvim_command('autocmd BufWritePre *.rs :silent! lua vim.lsp.buf.formatting_sync()')

-- Lua
lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
    },
  },
}
vim.api.nvim_command('autocmd BufWritePre *.lua :silent! lua vim.lsp.buf.formatting_sync()')

-- Nix
lspconfig.rnix.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- JS/TS
lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- C lang
lspconfig.clangd.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- Latex
lspconfig.texlab.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- JSON
lspconfig.jsonls.setup {
  -- Next line only for nix users
  cmd = { "json-languageserver", "--stdio" },
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}
vim.api.nvim_command('autocmd BufWritePre *.json :silent! lua vim.lsp.buf.formatting_sync()')

-- HTML
lspconfig.html.setup {
  -- Next line only for nix users
  cmd = { "html-languageserver", "--stdio" },
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}
vim.api.nvim_command('autocmd BufWritePre *.html :silent! lua vim.lsp.buf.formatting_sync()')

lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}
vim.api.nvim_command('autocmd BufWritePre *.py :silent! lua vim.lsp.buf.formatting_sync()')
