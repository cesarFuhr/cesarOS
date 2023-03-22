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

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Session Env Vars.
  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "rg --files -uu -g '!.git'";
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "google-chrome-stable";
    COMPOSE_COMPATIBILITY = "true";
  };

  # Packages to install.
  home.packages = with pkgs; [
    # Utils
    bitwarden
    bitwarden-cli
    simplenote
    neofetch
    gpick
    postman
    gnome.gnome-calculator
    zoxide
    nodePackages.graphite-cli

    # Browsers
    brave
    google-chrome

    # Work
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    openconnect
    teams

    # Comunication
    slack
    discord
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
    userName = "Cesar Cara";

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

  # SSH
  home.file.".ssh/config".text = ''
    AddKeysToAgent yes

    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/id_ed25519
  '';

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

    dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 300;
          offset = "30x50";
          origin = "top-right";
          transparency = 10;
        };

        urgency_normal = {
          timeout = 10;
        };
      };
    };
  };
}

