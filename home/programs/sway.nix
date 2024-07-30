{ pkgs, ... }:

{
  # Sway configuration.
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    systemd.enable = true;
    swaynag.enable = true;
    xwayland = true;

    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "tofi";
      defaultWorkspace = "1";

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];

      window = {
        titlebar = false;
        border = 1;
      };

      gaps = {
        smartBorders = "on";
      };

      input = {
        "type:keyboard" = {
          xkb_options = "caps:ctrl_modifier";
        };

        "type:touchpad" = {
          tap = "enable";
          drag = "enable";
        };
      };

      output = {
        "HDMI-A-1" = {
          mode = "3840x2160@60.000Hz";
          position = "1920,0";
        };

        "eDP-1" = {
          mode = "1920x1080@60.001Hz";
          position = "5760,1080";
        };
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
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+space" = "exec $(${p.tofi}/bin/tofi-run)";

          "${modifier}+Shift+q" = "kill";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" =
            "kxec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          # Gaps
          "${modifier}+Shift+o" = "gaps horizontal current plus 60";
          "${modifier}+Shift+i" = "gaps horizontal current minus 60";

          # Focus
          "${modifier}+w" = "focus output next";

          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # Move
          "${modifier}+Shift+w" = "move container to output next";

          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          # Layout
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+t" = "layout tabbed";

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

          # Scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";
        };
    };
  };

  gtk.cursorTheme = {
    package = pkgs.apple-cursor;
    name = "macOS-BigSur";
    size = 24;
  };

  home.pointerCursor = {
    package = pkgs.apple-cursor;
    name = "macOS-BigSur";
    size = 24;
    x11.defaultCursor = "macOS-BigSur";
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

