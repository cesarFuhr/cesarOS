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
    ./hardware/aorus.nix
  ];

  # Making nix ready for flakes.
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Setting env var to mark this build as aorus.
  environment.variables = {
    CESAR_OS_BUILD = "aorus";
  };

  # Latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "aorus"; # Define your hostname.
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

  # Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    xwayland.enable = true;
    extraPackages =
      let
        p = pkgs;
      in
      [
        p.swaylock
        p.swayidle
        p.wl-clipboard
        p.grim
        p.sway-contrib.grimshot
        p.slurp
        p.nwg-bar
        p.micro
        p.tofi
        p.wdisplays
        p.wlogout
        p.wallutils
        p.swww
        p.swappy
        p.foot
      ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      export XWAYLAND_NO_GLAMOR=1
      export WLR_RENDERER=vulkan
      export PROTON_ENABLE_WAYLAND=1
      export XKB_DEFAULT_OPTIONS=ctrl:swapcaps
    '';
  };

  services = {
    # Touchpads
    libinput.enable = true;

    # Display Manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember-session --cmd 'sway --unsupported-gpu'";
        };
      };
    };

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "grp:alt_shift_toggle,ctrl:nocaps,compose:rctrl";
      };

      # Video drivers
      videoDrivers = [ "amdgpu" ];
      enableTearFree = true;
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
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

      # Wayland
      p.glxinfo
      p.vulkan-tools
      p.glmark2

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
      p.bc
      p.pciutils
      p.psmisc
      p.fd
      p.openssl
      p.lshw
      p.inxi
      p.glxinfo
      p.parted
      p.dig
      p.qmk
      p.vial
      p.via
    ];

  # Enabling QMK devices
  hardware.keyboard.qmk.enable = true;

  # Vial
  services.udev.packages = with pkgs; [
    qmk-udev-rules
    vial
    via
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
        plugs.wlrobs
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

  system.stateVersion = "25.05";
}
