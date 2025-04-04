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
    -- Control + j to navigate down in the suggestions list.
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    -- Control + k to navigate up in the suggestions list.
    ['<C-j>'] = cmp.mapping.select_next_item(),
    -- Control + d to scroll down inside the docs of the suggestion.
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-3), { 'i', 'c' }),
    -- Control + f to scroll up inside the docs of the suggestion.
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(3), { 'i', 'c' }),
    -- Control + space to invoque the autocompletion menu.
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- Control + e to close the suggestion menu/window.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Return to confirm the selected suggestion.
    ['<C-;>'] = cmp.mapping.confirm({
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
    { name = 'nvim_lsp_signature_help' },
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
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local lspconfig = require 'lspconfig'
local telescopeBuiltin = require 'telescope.builtin'

local map = vim.keymap.set
-- Sets a function that will be called when a buffer with a supported
-- language is opened. This is how we configure the keybindings to lsp
-- when the language is supported, but left the keybindings as the default
-- otherwise.
local custom_lsp_attach = function()
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
  map('n', '<leader>f', function() vim.lsp.buf.format({ async = false }) end, { buffer = 0 })
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
local ardango = require "ardango"
local go_augroup = vim.api.nvim_create_augroup("go_lsp", { clear = true })

-- Update imports on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = go_augroup,
  pattern = "*.go",
  callback = function() ardango.OrgBufImports(1000) end,
})

lspconfig.gopls.setup {
  -- warns the LSP that it can send snippets suggestions.
  capabilities = capabilities,
  -- sets up lsp related functionality.
  on_attach = function()
    -- Adds tag element to the field under the cursor field.
    map('n', '<leader>taf', ardango.AddTagToField, { buffer = 0 })
    -- Adds tag element to all fields of the struct under the cursor field.
    map('n', '<leader>tas', ardango.AddTagsToStruct, { buffer = 0 })
    -- Removes tag element from the field under the cursor.
    map('n', '<leader>trf', ardango.RemoveTagFromField, { buffer = 0 })
    -- Removes tag element from the all fields of the struct under the cursor.
    map('n', '<leader>trs', ardango.RemoveTagsFromStruct, { buffer = 0 })

    -- Runs the test under the cursor.
    map('n', '<leader>rt', ardango.RunCurrTest, { buffer = 0 })

    custom_lsp_attach()
  end,
  -- gopls settings.
  settings = {
    gopls = {
      analyses = {
        shadow = true,
        unusedparams = true,
      },
      staticcheck = true,
    }
  }
}

local formatter_augroup = vim.api.nvim_create_augroup("lsp_formatters", { clear = true })
-- Formats the file on save.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = formatter_augroup,
  pattern = { "*.go", "*.c", "*.lua", "*.rs", "*.nix", "*.tf", "*.js", "*.ts", "*.jsx", "*.tsx" },
  callback = function() vim.lsp.buf.format({ async = false }) end,
})


-- Rust
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
  cmd = { "rust-analyzer" },
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

-- Lua
lspconfig.lua_ls.setup {
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

-- Nix
lspconfig.nixd.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
}

-- JS/TS
lspconfig.ts_ls.setup {
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
  cmd = { "vscode-json-language-server", "--stdio" },
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- HTML
lspconfig.html.setup {
  -- Next line only for nix users
  cmd = { "vscode-html-language-server", "--stdio" },
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- CSS
lspconfig.html.setup {
  -- Next line only for nix users
  cmd = { "vscode-css-language-server", "--stdio" },
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- Python
lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- Zig
lspconfig.zls.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- Elixir
lspconfig.elixirls.setup {
  cmd = { "elixir-ls" },
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- Terraform
lspconfig.terraformls.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- Markdown
lspconfig.marksman.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- Bash
lspconfig.bashls.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}

-- C#
lspconfig.csharp_ls.setup {
  capabilities = capabilities,
  on_attach = custom_lsp_attach,
}
