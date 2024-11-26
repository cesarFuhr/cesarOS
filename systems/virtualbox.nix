# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Making nix ready for flakes.
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Setting env var to mark this build as virtualbox.
  environment.variables.CESAR_OS_BUILD = "virtualbox";

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "cesar"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Video drivers
  services.xserver.videoDrivers = [ "modesetting" ];

  # Touchpads
  services.xserver.libinput.enable = true;

  # X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    displayManager = {
      gdm = {
        enable = true;
      };
      defaultSession = "none+awesome";
    };

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
      ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;

    users = {
      cesar = {
        isNormalUser = true;
        description = "cesar";
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
          "docker"
        ];

        shell = pkgs.zsh;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Editors
    neovim
    vim

    # Terminal
    kitty

    # Browsers
    firefox

    # Work
    git
    tree-sitter
    rnix-lsp
    docker
    docker-compose
    gnumake
    clang
    gcc
    python
    python3
    cmake
    fzf
    lua5_3
    lua53Packages.luarocks
    sumneko-lua-language-server
    rust-analyzer
    nodePackages.typescript-language-server

    # Environment
    dunst
    rofi
    picom
    dmenu
    feh
    materia-theme
    arc-theme
    alsa-lib
    alsa-utils
    alsa-tools
    pipecontrol

    # Utilities
    wget
    curl
    arandr
    xfce.thunar
    xfce.thunar-volman
    bat
    eza
    gnome.gnome-screenshot
    gzip
    htop
    jq
    iftop
    man-db
    unzip
    vlc
    zip
    usbutils
    zoom
    gparted
    xclip
    which
    ripgrep
    simplescreenrecorder
    bc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Zsh
  programs.zsh = {
    enable = true;
  };

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Mononoki"
          "FiraCode"
        ];
      })
    ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Audio
  services.pipewire = {
    enable = true;

    alsa.enable = false; # https://github.com/NixOS/nixpkgs/issues/157442
    alsa.support32Bit = false; # https://github.com/NixOS/nixpkgs/issues/157442

    pulse.enable = true;

    media-session.enable = false;

    wireplumber.enable = true;
  };

  # bluetooth stuff
  services.blueman.enable = true;
  hardware = {
    bluetooth.enable = true;
  };

  # Docker service deamon
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable";
}
