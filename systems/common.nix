{
  notes-script,
  pkgs,
  lib,
  ...
}:
{
  # Making nix ready for flakes.
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  # Bootloader.
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
      export QT_QPA_PLATFORM=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway
      LIBVA_DRIVER_NAME=radeonsi
    '';
  };

  environment.systemPackages =
    let
      p = pkgs;
      nd = pkgs.nodePackages;
    in
    [
      # Editors
      p.neovim

      # Browsers
      p.firefox

      # Wayland
      p.vulkan-tools
      p.glmark2
      p.mesa-demos

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
      nd.typescript-language-server
      p.vscode-langservers-extracted
      p.bash-language-server
      p.python3
      p.marksman

      # Environment
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
      p.nvtopPackages.amd
      p.btop
      p.jq
      p.iftop
      p.man-db
      p.unzip
      p.vlc
      p.zip
      p.usbutils
      p.gparted
      p.which
      p.ripgrep
      p.bc
      p.pciutils
      p.psmisc
      p.fd
      p.openssl
      p.lshw
      p.inxi
      p.parted
      p.dig
      p.qmk
      p.vial
      p.via
    ];

  services = {
    # Touchpads
    libinput.enable = true;

    # Display Manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember-session --cmd 'sway'";
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

  programs.tmux = {
    enable = true;
    secureSocket = true;
    shortcut = "s";
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set -s extended-keys on
      unbind C-\;

      # Clock
      set-window-option -g clock-mode-colour cyan
      set-window-option -g clock-mode-style 24

      # Statusline
      set-option -g status-position top
      set -wg status-justify right
      set -wg window-status-format '  #I|#W  '
      set -wg window-status-current-format '#[bg=#111316]  #[fg=cyan,bold]#I|#W  '
      set -wg 'status-format[1]' '#[bg=#002F343F] #[fg=#002F343F]'
      set  -g window-status-activity-style 'bg=#12131D,fg=yellow,blink'
      set  -g message-style 'bg=#12131D fg=colour5,bright'
      set  -g status-style 'bg=#12131D fg=#3B4260'
      set  -g status-left  '#[fg=white,bright]'
      set  -g status-right '  #[fg=colour105,bright][#[fg=colour5,bright] #S / #P #[fg=colour105,bright]]'
    '';
  };

  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;

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

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    11111
    22222 # internalssh
  ];

  services.tailscale.enable = true;

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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
