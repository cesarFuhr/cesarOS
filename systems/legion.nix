# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware/legion.nix
    ];

  # Making nix ready for flakes.
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Setting env var to mark this build as legion.
  environment.variables.CESAR_OS_BUILD = "legion";

  # Latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

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
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    extraHosts = ''
      127.0.0.1 aws
    '';
  };

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


  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  # Touchpads
  services.xserver.libinput.enable = true;

  # etc settings
  environment.etc = {
    # keychron K3 - mediakeys
    "modprobe.d/hid_apple.conf".text = ''
      options hid_apple fnmode=1
    '';
  };

  # X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";

    # Video drivers
    # Nvidia
    videoDrivers = [ "nvidia" ];
    dpi = lib.mkForce 120;

    displayManager = {
      startx.enable = true;
      lightdm = {
        enable = true;
        greeters = {
          gtk = {
            enable = true;
            theme = {
              name = "Sierra-dark";
              package = pkgs.sierra-gtk-theme;
            };
          };
        };
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

    xkbOptions = "ctrl:nocaps";
  };

  # Picom
  services.picom = {
    enable = true;
    vSync = true;
  };

  console.useXkbConfig = true;

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


  # Allow python 2.7 and nodejs 16
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.7"
    "nodejs-16.20.0"
  ];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs;
    let
      nd = pkgs.nodePackages;
    in
    [
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
      clang-tools
      gcc
      cmake
      fzf
      lua5_3
      lua53Packages.luarocks
      lua-language-server
      nodejs
      yarn
      cargo
      rustc
      rustup
      rust-analyzer
      clippy
      terraform
      nd.typescript-language-server
      nd.vscode-json-languageserver-bin
      nd.vscode-html-languageserver-bin
      python
      python3

      # Environment
      rofi
      dmenu
      feh
      arc-theme
      alsa-lib
      alsa-utils
      alsa-tools
      pamixer
      pulseaudio

      # Utilities
      wget
      curl
      arandr
      cinnamon.nemo
      bat
      eza
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
      psmisc
      fd
      openssl
      lshw
      inxi
      glxinfo
      parted
      system-config-printer
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

  # Manually enabling dconf. 
  # (needed because gnome is not a dep anymore, moved from gdm to lightdm)
  programs.dconf.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 11111 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  sound.enable = true;

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Flatpack
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Docker service deamon
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      default-ulimits = {
        nofile = {
          Hard = 64000;
          Name = "nofile";
          Soft = 64000;
        };
      };
    };
  };

  nix = {
    optimize.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable";
}
