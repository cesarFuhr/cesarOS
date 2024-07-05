# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ notes-script, config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware/inspiron.nix
    ];

  # Making nix ready for flakes.
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Setting env var to mark this build as legion.
  environment.variables.CESAR_OS_BUILD = "inspiron";

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

  services.desktopManager.plasma6.enable = true;

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
        ];

        shell = pkgs.zsh;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
      p.firefox-bin

      # Work
      notes-script.packages.${p.system}.notes
      notes-script.packages.${p.system}.todo
      notes-script.packages.${p.system}.todo-done
      p.git
      p.tree-sitter
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
      p.python
      p.python3
      p.marksman

      # Utilities
      p.wget
      p.curl
      p.arandr
      p.cinnamon.nemo
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
    ];

  # Zsh
  programs.zsh = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  sound.enable = true;

  nix = {
    optimise.automatic = true;
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
