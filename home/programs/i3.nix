{ pkgs, ... }:

{
  # i3 configuration.
  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "dmenu_run";
      defaultWorkspace = "1";

      startup = [
        {
          command = ''
            feh -z --bg-fill $HOME/Wallpapers
          '';
        }
      ];

      bars = [];

      window = {
        titlebar = false;
        border = 1;
      };

      gaps = {
        smartBorders = "on";
      };

      keybindings =
        let
          p = pkgs;
          left = "h";
          up = "k";
          right = "l";
          down = "j";
        in
        {
          "${modifier}+Shift+Return" = "exec ${terminal}";
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+space" = "exec $(${p.dmenu}/bin/dmenu_run)";
          "${modifier}+semicolon" = "exec $(${p.dmenu}/bin/demnu_run)";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+q" = "kill";
          "${modifier}+Shift+p" = "exec wlogout";

          # Screenshot
          "${modifier}+home" = "exec grimshot copy area";
          "Print" = ''exec grim -g "$(slurp)" - | swappy -f -  '';
          "${modifier}+Shift+home" = "exec grimshot save area";
          "Shift+Print" = "exec grimshot copy area";

          # Switching keyboard layout/variant
          "${modifier}+Shift+Prior" = ''input "1:1:AT_Translated_Set_2_keyboard" xkb_switch_layout next'';

          # Gaps
          "${modifier}+Shift+period" = "gaps horizontal current plus 60";
          "${modifier}+Shift+comma" = "gaps horizontal current minus 60";

          # Focus
          "${modifier}+o" = "focus output right";

          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # Move
          "${modifier}+Shift+o" = "move output right";

          "${modifier}+Shift+a" = "move container to workspace number 1";
          "${modifier}+Shift+s" = "move container to workspace number 2";
          "${modifier}+Shift+d" = "move container to workspace number 3";
          "${modifier}+Shift+f" = "move container to workspace number 4";
          "${modifier}+Shift+g" = "move container to workspace number 5";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          # Layout
          "${modifier}+w" = "fullscreen toggle";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+t" = "layout tabbed";

          # Workspaces
          "${modifier}+a" = "workspace number 1";
          "${modifier}+s" = "workspace number 2";
          "${modifier}+d" = "workspace number 3";
          "${modifier}+f" = "workspace number 4";
          "${modifier}+g" = "workspace number 5";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          # Scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          # Audio
          XF86AudioMute = "exec ${p.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          XF86AudioPlay = "exec ${p.playerctl}/bin/playerctl play-pause";
          XF86AudioNext = "exec ${p.playerctl}/bin/playerctl next";
          XF86AudioPrev = "exec ${p.playerctl}/bin/playerctl previous";
          XF86AudioRaiseVolume = "exec ${p.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          XF86AudioLowerVolume = "exec ${p.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        };
    };
  };

  gtk.font = {
    name = "Sans";
    size = 11;
  };

  programs.tofi = {
    enable = true;
    settings = {
      anchor = "top";
      width = "100%";
      height = 26;
      horizontal = true;
      font = "monospace";
      font-size = 12;
      prompt-text = " run: ";
      outline-width = 0;
      border-width = 0;
      background-color = "#000000";
      selection-color = "#3d7deb";
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 0;
      padding-bottom = 0;
      padding-left = 0;
      padding-right = 0;
    };
  };
}

