require 'cesar.remap'
require 'cesar.set'
require 'cesar.packer'
require 'cesar.theme'

function R(name)
  require 'plenary.reload'.reload_module(name)
end

function P(o)
  print(vim.inspect(o))
end
