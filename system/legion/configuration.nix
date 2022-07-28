# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Making nix ready for flakes.
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Setting env var to mark this build as legion.
  environment.variables.CESAR_OS_BUILD = "legion";

  # Latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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


  # Touchpads
  services.xserver.libinput.enable = true;

  # Copy the display script.
  environment.etc = {
    "display.py".source = ./display.py;
  };

  # X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    # Video drivers
    # Nvidia
    videoDrivers = [ "nvidia" ];
    dpi = 120;

    displayManager = {
      gdm = { enable = true; };
      defaultSession = "none+awesome";

      sessionCommands = ''
        python3 /etc/display.py
      '';
      setupCommands = ''
        python3 /etc/display.py
      '';
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
        extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];

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
    firefox-bin

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
    nodejs
    yarn
    rustc
    rustup
    rust-analyzer
    terraform
    gotools
    gopls
    go-outline
    gocode
    gopkgs
    gocode-gomod
    godef
    golint
    nodePackages.typescript-language-server

    # Environment
    dunst
    rofi
    picom
    cups
    dmenu
    feh
    materia-theme
    arc-theme
    alsa-lib
    alsa-utils
    alsa-tools
    pipecontrol
    pamixer
    pulseaudio

    # Utilities
    wget
    curl
    arandr
    xfce.thunar
    xfce.thunar-volman
    bat
    exa
    gnome.gnome-screenshot
    gzip
    htop
    nvtop
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
    pciutils
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
      (nerdfonts.override { fonts = [ "Mononoki" "FiraCode" ]; })
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

  sound.enable = true;

  # Bluetooth
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
