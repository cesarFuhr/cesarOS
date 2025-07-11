# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  notes-script,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware/rogstrix.nix
  ];

  # Making nix ready for flakes.
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Setting env var to mark this build as rogstrix.
  environment.variables = {
    CESAR_OS_BUILD = "rogstrix";
  };

  # Latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rogstrix"; # Define your hostname.
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
      127.0.0.1 local-site.bnet.run
      127.0.0.1 local-creations.bnet.run
      127.0.0.1 local-api.bnet.run
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

  environment.variables.XCURSOR_SIZE = "24";

  # X11
  services = {
    displayManager.defaultSession = "none+i3";

    # Touchpads
    libinput.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us,us";
        variant = ",intl";
        options = "grp:alt_shift_toggle,ctrl:nocaps,compose:rctrl";
      };

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

        sessionCommands = "${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr";
      };

      windowManager.i3 = {
        enable = true;
      };
    };
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
    "python-2.7.18.8"
    "nodejs-16.20.0"
  ];

  # List packages installed in system profile.
  environment.systemPackages =
    let
      p = pkgs;
      nd = pkgs.nodePackages;
    in
    [
      # Editors
      p.neovim
      p.vim

      # Terminal
      p.alacritty

      # Browsers
      p.firefox

      # OBS
      p.v4l-utils

      # Work
      notes-script.packages.${p.system}.notes
      notes-script.packages.${p.system}.todo
      notes-script.packages.${p.system}.todo-done
      p.git
      p.tree-sitter
      p.nixd
      p.nixfmt-rfc-style
      p.nixpkgs-lint
      p.nixd
      p.docker
      p.docker-compose
      p.gnumake
      p.clang
      p.clang-tools
      p.gcc
      p.cmake
      p.fzf
      p.lua5_3
      p.lua53Packages.luarocks
      p.lua-language-server
      p.nodejs
      p.yarn
      p.cargo
      p.rustc
      p.rustup
      p.rust-analyzer
      p.clippy
      p.terraform
      nd.typescript-language-server
      p.vscode-langservers-extracted
      p.bash-language-server
      p.python
      p.python3
      p.marksman

      # Environment
      p.rofi
      p.dmenu-rs-enable-plugins
      p.feh
      p.arc-theme
      p.alsa-lib
      p.alsa-utils
      p.alsa-tools
      p.pamixer
      p.pulseaudio

      # Audio
      p.pavucontrol
      p.playerctl

      # Utilities
      p.wget
      p.curl
      p.arandr
      p.nemo
      p.bat
      p.eza
      p.gzip
      p.htop
      p.nvtopPackages.full
      p.btop
      p.jq
      p.iftop
      p.man-db
      p.unzip
      p.vlc
      p.zip
      p.usbutils
      p.zoom
      p.gparted
      p.xclip
      p.which
      p.ripgrep
      p.simplescreenrecorder
      p.bc
      p.pciutils
      p.psmisc
      p.fd
      p.openssl
      p.lshw
      p.inxi
      p.glxinfo
      p.parted
      p.system-config-printer
      p.dig
      p.xorg.xev
      p.qmk
      p.vial
      p.via
    ];

  # Vial
  services.udev.packages = with pkgs; [
    qmk-udev-rules
    vial
    via
  ];

  # Enabling QMK devices
  hardware.keyboard.qmk.enable = true;

  # Gnome keyring

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

  # OBS
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins =
      let
        plugs = pkgs.obs-studio-plugins;
      in
      [
        plugs.obs-backgroundremoval
        plugs.obs-pipewire-audio-capture
      ];
  };

  # Manually enabling dconf.
  # (needed because gnome is not a dep anymore, moved from gdm to lightdm)
  programs.dconf.enable = true;

  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;

  # List services that you want to enable:

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      nerd-fonts.jetbrains-mono
    ];
  };

  # Pipewire.
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber = {
      enable = true;
    };
    pulse.enable = true;

    extraConfig.pipewire.noresample = {
      "context.properties" = {
        "default.clock.allowed-rates" = [
          44100
          48000
          192000
        ];
      };
    };
  };

  # Remove sound crackling:
  security.rtkit.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Steam.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    11111
    22222 # internalssh
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
    wlr.enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
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

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
  users.extraGroups.vboxusers.members = [ "cesar" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
