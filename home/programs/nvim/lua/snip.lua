-- Currrently only has Go snippets


local ls = require 'luasnip'

ls.config.set_config {
  history = true,
  update_events = 'TextChanged,TextChangedI',
  enable_autosnipets = true,
}

-- <c-l> is my expansion key
vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-h> is my backwards key
vim.keymap.set({ "i", "s" }, "<c-h>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-o> is my cicles through the list of options key
vim.keymap.set({ "i" }, "<c-o>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- shortcut to source my luasnips file again, which will reload my snippets
vim.keymap.set("n", "<leader>ss", "<cmd>source ~/.local/share/nvim/plugged/LuaSnip/plugin/luasnip.vim<CR>")

local s, i, t = ls.s, ls.insert_node, ls.text_node
local c, sn = ls.choice_node, ls.sn

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("go", {
  -- Fundamentals
  -- Function
  s({
    dscr="f expands a go func.",
    trig="f",
  }, fmt(
[[func {}({}) {} {{
  {}
}}]], { i(1, "name"), i(2), i(3), i(0)})),
  -- Method
  s({
    dscr="meth expands a method.",
    trig="meth",
  }, fmt(
[[func ({} {}) {}({}) {} {{
  {}
}}]], { i(1, "r"), i(2, "Receiver"), i(3, "name"), i(4), i(5), i(0) })),
  -- Defered function
  s({
    dscr="df expands a defered anonymous func.",
    trig="df",
  }, fmt(
[[defer func({}) {{
  {}
}}({})]], { i(1), i(0), i(2) })),
  -- Go routine with anonymous function
  s({
    dscr="gof expands a go routine with a function.",
    trig="gof",
  }, fmt(
[[go func({}) {{
  {}
}}({})]], { i(1), i(0), i(2) })),
  -- For loop
  s({
    dscr="for expands a for loop.",
    trig="for",
  }, fmt(
[[for {} := {}; {} {}; {}{} {{
  {}
}}]], { i(1), i(2), rep(1), i(3), rep(1), i(4), i(0) })),
  -- For range loop, has some options.
  s({
    dscr="forr expands a for loop\nhas 3 options: slice, map, custom.",
    trig="forr",
  }, fmt(
[[for {} := range {} {{
  {}
}}]],
  {
    c(1, {t "i, v", t "k, v", sn(nil, { i(1) }) }),
    i(2),
    i(0),
  })),
  s({
    dscr="if expands in a if statement.",
    trig="if",
  }, fmt(
[[if {} {{
  {}
}}]],{ i(1), i(0)})),
  -- If err != nil
  s({
    dscr=[[iferr expands in a if err != nil statement.
It has two options: err != nil and inline err declaration.]],
    trig="iferr",
  }, fmt(
[[if {} {{
  return {}
}}]], {
  c(1,
  {
    t "err != nil",
    sn(nil, { i(1, "err"), t " := ", i(2, "funcCall()"), t "; ", rep(1), t " != nil" }),
    sn(nil, { i(1), t ", ", i(2, "err"), t " := ", i(3, "funcCall()"), t "; ", rep(2), t " != nil" }),
  }),
  i(0),
})),

  -- Testing
  -- Test function
  s({
    dscr="t expands in a test function.",
    trig="t",
  }, fmt(
[[func Test{}(t *testing.T) {{
  {}
}}]], { i(1, "Name"), i(0)})),
  -- t.Run()
  s({
    dscr="tr expands in a test function.",
    trig="tr",
  }, fmt(
[[t.Run("{}", func(t *testing.T) {{
  {}
}})]], { i(1, "test description"), i(0)})),

  -- Type declaration
  -- Struct declaration
  s({
    dscr="tys expands in a type struct declaration.",
    trig="tys",
  }, fmt(
[[type {} struct {{
  {}
}}]],{ i(1, "Name"), i(0)})),
  -- interface declaration
  s({
    dscr="tyi expands in a type interface declaration.",
    trig="tyi",
  }, fmt(
[[type {} interface {{
  {}
}}]],{ i(1, "Name"), i(0)})),
})
