{ config, pkgs, ... }:

{
  # Nvim configuration.
  # I really enjoy working with neovim as intended, with its lua configs.
  # So I am gonna load the files in the config dir directly.
  # Loading config files in the $XDG_CONFIG_HOME folder.
  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lua/_telescope.lua".source = ./nvim/lua/_telescope.lua;
  xdg.configFile."nvim/lua/keymaps.lua".source = ./nvim/lua/keymaps.lua;
  xdg.configFile."nvim/lua/lsp.lua".source = ./nvim/lua/lsp.lua;
  xdg.configFile."nvim/lua/plugins.lua".source = ./nvim/lua/plugins.lua;
  xdg.configFile."nvim/lua/settings.lua".source = ./nvim/lua/settings.lua;
  xdg.configFile."nvim/lua/snip.lua".source = ./nvim/lua/snip.lua;
  xdg.configFile."nvim/lua/theme.lua".source = ./nvim/lua/snip.lua;
}

