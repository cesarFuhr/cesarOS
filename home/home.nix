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
    bitwarden-cli
    simplenote
    neofetch
    rclone

    # Browsers
    brave
    google-chrome

    # Work
    awscli
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc

    # Comunication
    slack
    skypeforlinux
    zoom-us

    # Audio
    pavucontrol
    playerctl
  ];

  # Bigger configurations.
  imports = [
    # Awesome window manager.
    # The first build will fail, since lcpz/lain package is 
    # missing. Clone it to ~/.config/awesome/lain and restart
    # awesomewm.
    ./programs/awesome/awesome.nix

    # Neovim will be installed but the plugins must be installed.
    # This will happend in the first neovim run, sometimes
    # some plugins will fail to be downloaded in the first try,
    # retry and it will probably have success.
    # This should be done after setting up the git ssh keys to the
    # user.
    ./programs/nvim/nvim.nix

    ./programs/rofi.nix
    ./programs/zsh.nix
    ./programs/kitty.nix
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Sierra-dark";
      package = pkgs.sierra-gtk-theme;
    };
  };

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

