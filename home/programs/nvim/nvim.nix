{ config, pkgs, ... }:

{
  # Nvim configuration.
  # I really enjoy working with neovim as intended, with its lua configs.
  # So I am gonna load the files in the config dir directly.
  # Loading config files in the $XDG_CONFIG_HOME folder.
  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/lua/cesar".source = ./lua/cesar;
  home.file.".config/nvim/after/plugin".source = ./after/plugin;
}

