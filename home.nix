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
  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "rg --files -uu -g '!.git'";
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "brave";
  };

  # Packages to install.
  home.packages = with pkgs; [
    # Utils
    spotify
    bitwarden

    # Browsers
    brave
    google-chrome

    # Comunication
    slack
    skypeforlinux
    zoom-us
  ];

  # AwesomeWM.
  xsession.windowManager.awesome = {
    enable = true;
  };
  xdg.configFile."awesome/rc.lua".source = ./programs/awesome/rc.lua;

  # Bigger configurations.
  imports = [
    ./programs/rofi.nix
    ./programs/zsh.nix
    ./programs/nvim/nvim.nix
    ./programs/kitty.nix
  ];

  # Golang setup.
  programs.go = {
    enable = true;
    goBin = "go/bin";
    goPath = "go";
  };

  # Git
  programs.git = {
    enable = true;
    userEmail = "cesar.cara@protonmail.com";
    userName = "cesarFuhr";

    diff-so-fancy.enable = true;

    signing = {
      key = "AB688197ABB2A0D4";
      signByDefault = true;
    };

    extraConfig = {
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
      url = {
        "ssh://git@github.com/" = { insteadOf = "https://github.com/"; };
      };
    };
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


