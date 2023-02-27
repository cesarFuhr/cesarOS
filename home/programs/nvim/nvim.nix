{ config, pkgs, ... }:

{
  # Nvim configuration.
  # I really enjoy working with neovim as intended, with its lua configs.
  # So I am gonna load the files in the config dir directly.
  # Loading config files in the $XDG_CONFIG_HOME folder.
  xdg.configFile."nvim/init.lua".source = ./init.lua;

  # Cesar
  xdg.configFile."nvim/lua/cesar/init.lua".source = ./lua/cesar/init.lua;
  xdg.configFile."nvim/lua/cesar/set.lua".source = ./lua/cesar/set.lua;
  xdg.configFile."nvim/lua/cesar/remap.lua".source = ./lua/cesar/remap.lua;
  xdg.configFile."nvim/lua/cesar/packer.lua".source = ./lua/cesar/packer.lua;


  # After
  xdg.configFile."nvim/after/plugin/lsp.lua".source = ./after/plugin/lsp.lua;
  xdg.configFile."nvim/after/plugin/theme.lua".source = ./after/plugin/theme.lua;
  xdg.configFile."nvim/after/plugin/gitsigns.lua".source = ./after/plugin/gitsigns.lua;
  xdg.configFile."nvim/after/plugin/snip.lua".source = ./after/plugin/snip.lua;
  xdg.configFile."nvim/after/plugin/fterm.lua".source = ./after/plugin/fterm.lua;
  xdg.configFile."nvim/after/plugin/lualine.lua".source = ./after/plugin/lualine.lua;
  xdg.configFile."nvim/after/plugin/telescope.lua".source = ./after/plugin/telescope.lua;
  xdg.configFile."nvim/after/plugin/treesitter.lua".source = ./after/plugin/treesitter.lua;
}

