{ pkgs, ... }:

{
  # Sway configuration.
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    systemd.enable = true;
    swaynag.enable = true;
    xwayland = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "wofi";
      defaultWorkspace = "1";

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];

      window = {
        titlebar = false;
        border = 1;
      };

      gaps = {
        smartGaps = true;
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
          modifier = "Mod4";
        in
        pkgs.lib.mkOptionDefault {
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Space" = "swaymsg exec -- $(tofi-run)";
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
      height = 30;
      horizontal = true;
      font = "monospace";
      font-size = 14;
      prompt-text = " run: ";
      outline-width = 0;
      border-width = 0;
      background-color = "#000000";
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 0;
      padding-bottom = 0;
      padding-left = 0;
      padding-right = 0;
    };
  };
}

