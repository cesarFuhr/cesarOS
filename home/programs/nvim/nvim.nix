{ config, pkgs, ... }:

{
  # Nvim configuration.
  # I really enjoy working with neovim as intended, with its lua configs.
  # So I am gonna load the files in the config dir directly.
  # Loading config files in the $XDG_CONFIG_HOME folder.

  # Neovim will be installed but the plugins must be installed.
  # This will happend in the first neovim run, sometimes
  # some plugins will fail to be downloaded in the first try,
  # retry and it will probably have success.
  # This should be done after setting up the git ssh keys to the
  # user.

  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/lua/cesar".source = ./lua/cesar;
  home.file.".config/nvim/after/plugin".source = ./after/plugin;
}

