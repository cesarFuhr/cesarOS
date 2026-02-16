{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.cesarOS;
in

{
  options = {
    cesarOS = {
      terminal = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.foot;
          description = "Terminal emulator package to use.";
        };
      };

      displays = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              resolution = lib.mkOption {
                type = lib.types.str;
                default = "3840x2160";
                description = "Display resolution (e.g., '1920x1080')";
              };

              frequency = lib.mkOption {
                type = lib.types.str;
                default = "60";
                description = "Display frequency (e.g., '60.00')";
              };

              position = lib.mkOption {
                type = lib.types.str;
                default = "0,0";
                description = "Display position (e.g., '1920x0')";
              };

              primary = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether this is the primary display";
              };

              scale = lib.mkOption {
                type = lib.types.float;
                default = 1.0;
                description = "Display scaling factor";
              };

              transform = lib.mkOption {
                type = lib.types.str;
                default = "0";
                description = "Usually the rotation of the monitor.";
              };
            };
          }
        );
        default = { };
        description = "Display configurations keyed by display name";
      };

      fontSize = lib.mkOption {
        type = lib.types.int;
        default = 12;
        description = "Default font size for applications";
      };
    };
  };

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
    ./programs/zed_config.nix
    ./programs/ghostty.nix
  ];

  config = {
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      username = "cesar";
      homeDirectory = "/home/cesar";

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.

      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "26.05";

      sessionVariables = {
        FZF_DEFAULT_COMMAND = "rg --files -uu -g '!.git'";
        EDITOR = "nvim";
        TERMINAL = "foot";
        BROWSER = "google-chrome-stable";
        COMPOSE_COMPATIBILITY = "true";
        GTK_THEME = "Sierra-dark";
      };

      # Packages to install.
      packages =
        let
          p = pkgs;
        in
        [
          # Utils
          p.neofetch
          p.gnome-calculator
          p.entr
          p.xdg-utils
          p.proton-pass
          p.protonvpn-gui

          # Browsers
          p.google-chrome

          # Communication
          p.weechat
          p.slack

          # Work
          p.openconnect
          p.bruno
          p.vscode
          p.amp-cli
          p.claude-code
          p.github-copilot-cli
        ];

      # Keyboard
      file.".config/kb.vil".source = ./kb.vil;
    };

    gtk = {
      enable = true;
      theme = {
        name = "Sierra-dark";
        package = pkgs.sierra-gtk-theme;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk2 = {
        iconTheme = {
          name = "Sierra-dark";
          package = pkgs.sierra-gtk-theme;
        };
      };

      gtk3 = {
        iconTheme = {
          name = "Sierra-dark";
          package = pkgs.sierra-gtk-theme;
        };

        extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=true
          '';
        };
      };

      gtk4 = {
        extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=true
          '';
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
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
      env = {
        GOBIN = "/home/cesar/go/bin";
        GOPATH = "/home/cesar/go";
      };
    };

    # Git
    programs.git = {
      enable = true;
      settings = {
        user.name = "Cesar Cara";
        core = {
          editor = "nvim";
        };
        init = {
          defaultBranch = "main";
        };
        url = {
          "ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
        };
        include = {
          path = "./user_config";
        };
      };

      signing = {
        signByDefault = true;
      };
    };

    programs.diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };

    # Git user management.
    home.file.".config/git/user_config".text = ''
      [user]
        email = "cesar.cara@protonmail.com"
        signingKey = "AB688197ABB2A0D4"

      [core]
        sshCommand = ssh -o "IdentitiesOnly=yes" -i /home/cesar/.ssh/id_ed25519

      [includeIf "gitdir:/home/cesar/work/ardanlabs/bethesda/"]
        path = "./work_config"
    '';

    home.file.".config/git/work_config".text = ''
      [user]
        email = "cesar.cara@contractor.zenimax.com"
        signingKey = "C086847788CF3554"

      [core]
        sshCommand = ssh -o "IdentitiesOnly=yes" -i /home/cesar/.ssh/ardan-bnet
    '';

    # SSH
    home.file.".ssh/config".text = ''
      AddKeysToAgent yes

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

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    services = {
      gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
        enableZshIntegration = true;
        pinentry.package = pkgs.pinentry-gtk2;
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
  };
}
