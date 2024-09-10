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
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Session Env Vars.
  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "rg --files -uu -g '!.git'";
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    BROWSER = "google-chrome-stable";
    COMPOSE_COMPATIBILITY = "true";
    GTK_THEME = "Sierra-dark";
  };

  home.pointerCursor = {
    package = pkgs.apple-cursor;
    name = "macOS-BigSur";
    x11.defaultCursor = "macOS-BigSur";
  };

  # Packages to install.
  home.packages = let p = pkgs; in
    [
      # Utils
      p.neofetch
      p.gpick
      p.gnome-calculator
      p.zoxide
      p.entr
      p.xdg-utils
      p.bitwarden-desktop

      # Browsers
      p.brave
      p.google-chrome

      # Communication
      p.weechat
      p.slack

      # Work
      p.openconnect
      p.bruno
    ];

  # Bigger configurations.
  imports = [
    # Neovim will be installed but the plugins must be installed.
    # This will happend in the first neovim run, sometimes
    # some plugins will fail to be downloaded in the first try,
    # retry and it will probably have success.
    # This should be done after setting up the git ssh keys to the
    # user.
    ./programs/nvim/nvim.nix
    ./programs/alacritty.nix
    ./programs/zsh.nix
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Sierra-dark";
      package = pkgs.sierra-gtk-theme;
    };

    cursorTheme = {
      package = pkgs.apple-cursor;
      name = "macOS-BigSur";
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=true
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=true
      '';
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adawaita";
    style = {
      name = "Sierra-dark";
      package = pkgs.sierra-gtk-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
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

    Host *sr.ht
      User git
      IdentityFile ~/.ssh/id_ed25519
      PreferredAuthentications publickey

    Host stable-bastion
      StrictHostKeyChecking no
      User ec2-user
      IdentityFile ~/.ssh/bnet-stable-bastion.pem
      ProxyCommand bash -c "aws ssm start-session --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --target $(aws ec2 describe-instances --filter "Name=tag:Name,Values=LinuxBastion" "Name=tag:Environment,Values=Stable" "Name=tag:Business Unit,Values=BNET" --query "Reservations[].Instances[?State.Name == 'running'].InstanceId[] | [0]" --output text)"
    
    Host i-* mi-*
      StrictHostKeyChecking no
      User ec2-user
      ProxyCommand sh -c "aws --profile stable-bastion ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    
    Host prod-bastion
      StrictHostKeyChecking no
      User ec2-user
      IdentityFile ~/.ssh/bnet-prod-bastion.pem
      ProxyCommand bash -c "aws --profile prod-bastion ssm start-session --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --target $(aws --profile prod-bastion ec2 describe-instances --filter "Name=tag:Name,Values=LinuxBastion" "Name=tag:Environment,Values=Production" "Name=tag:Business Unit,Values=BNET" --query "Reservations[].Instances[?State.Name == 'running'].InstanceId[] | [0]" --output text)"
  '';

  programs.gpg = {
    enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      enableZshIntegration = true;
      pinentryPackage = pkgs.pinentry-gtk2;
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
          frame_color = "#111111";
          font = "Droid Sans 12";
        };

        urgency_normal = {
          timeout = 10;
        };
      };
    };
  };
}

