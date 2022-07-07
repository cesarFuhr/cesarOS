{ config, pkgs, ... }:

{
  # Nvim configuration.
  # I really enjoy working with neovim as intended, with its lua configs.
  # So I am gonna load the files in the config dir directly.
  # Loading config files in the $XDG_CONFIG_HOME folder.
  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua/_telescope.lua".source = ./lua/_telescope.lua;
  xdg.configFile."nvim/lua/keymaps.lua".source = ./lua/keymaps.lua;
  xdg.configFile."nvim/lua/lsp.lua".source = ./lua/lsp.lua;
  xdg.configFile."nvim/lua/plugins.lua".source = ./lua/plugins.lua;
  xdg.configFile."nvim/lua/settings.lua".source = ./lua/settings.lua;
  xdg.configFile."nvim/lua/snip.lua".source = ./lua/snip.lua;
  xdg.configFile."nvim/lua/theme.lua".source = ./lua/theme.lua;
}

