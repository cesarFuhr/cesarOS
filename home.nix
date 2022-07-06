{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Session Env Vars.
  home.sessionVariables.FZF_DEFAULT_COMMAND = "rg --files -uu -g '!.git'";

  # AwesomeWM.
  xsession.windowManager.awesome = {
      enable = true;
    };
  xdg.configFile."awesome/rc.lua".source = ./programs/awesome/rc.lua;

  # Packages to install.
  home.packages = with pkgs; [
    # Utils
    spotify
    bitwarden
    
    # Browsers
    brave
    google-chrome

    # Messaging
    slack
    skypeforlinux
  ];

  # Bigger configurations.
  imports = [
    ./programs/rofi/rofi.nix
    ./programs/zsh.nix
    ./programs/nvim/nvim.nix
  ];

  # Golang setup.
  programs.go = {
    enable = true;
    goBin = "go/bin";
    goPath = "go";
  };

  programs.gpg = {
    enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    picom = {
      enable = true;
      vSync = true;
    };
  };

}


