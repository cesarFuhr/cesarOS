require 'cesar.remap'
require 'cesar.set'
require 'cesar.lazy'

function R(name)
  require 'plenary.reload'.reload_module(name)
end

function P(o)
  print(vim.inspect(o))
end
