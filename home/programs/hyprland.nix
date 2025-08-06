{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.hyprland;
in

{
  options = {
    hyprland = {
      primaryDisplay = lib.mkOption {
        default = "missingDisplay";
        type = lib.types.str;
      };
      secondaryDisplay = lib.mkOption {
        default = "missingDisplay";
        type = lib.types.str;
      };
    };
  };

  # Hyprland configuration.
  config.wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "foot";
      "$menu" = "tofi-run";

      monitor = [
        "${config.hyprland.primaryDisplay}, 3840x2160@600, 0x0, 1"
        "${config.hyprland.secondaryDisplay}, 1920x1200@165.01, 3840x960, 1"
      ];

      exec-once = [
        "waybar"
        "swww-daemon"
        "swww img $(find ~/Wallpapers -maxdepth 1 -type f | shuf -n 1)"
      ];

      env = [
        "XCURSOR_THEME,capitaine-cursors"
        "XCURSOR_SIZE,24"

        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "GBM_BACKEND,nvidia-drm"
        "XDG_SESSION_TYPE,wayland"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;

        "col.active_border" = "rgba(1199ccdd)";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = false;
        allow_tearing = false;

        layout = "master";
      };

      decoration = {
        rounding = 0;
        rounding_power = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow.enabled = false;
        blur.enabled = false;
      };

      animations.enabled = false;

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "slave";
        inherit_fullscreen = true;
        mfact = 0.50;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us,us";
        kb_variant = ",intl";
        kb_options = "grp:alt_shift_toggle,ctrl:nocaps,compose:rctrl";

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };

      cursor = {
        no_hardware_cursors = 1;
        no_break_fs_vrr = true;
      };

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      gestures.workspace_swipe = false;

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod SHIFT, Return, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, T, fullscreen, 1"
        "$mainMod, Space, exec, $menu | xargs hyprctl dispatch exec --"
        "$mainMod, SemiColon, exec, $menu | xargs hyprctl dispatch exec --"
        "$mainMod SHIFT, P, exec, wlogout"
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f - "
        "SHIFT, Print, exec, grimshot copy area"

        # Manage windows
        "$mainMod, h, layoutmsg, cyclenext"
        "$mainMod, l, layoutmsg, cycleprev"
        "$mainMod, k, movefocus, u"
        "$mainMod SHIFT, k, layoutmsg, swapwithmaster"
        "$mainMod, j, movefocus, d"
        "$mainMod, o, focusmonitor, +1"
        "$mainMod SHIFT, o, movewindow, mon:+1"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, a, workspace, 1"
        "$mainMod, s, workspace, 2"
        "$mainMod, d, workspace, 3"
        "$mainMod, f, workspace, 4"
        "$mainMod, g, workspace, 5"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, a, movetoworkspace, 1"
        "$mainMod SHIFT, s, movetoworkspace, 2"
        "$mainMod SHIFT, d, movetoworkspace, 3"
        "$mainMod SHIFT, f, movetoworkspace, 4"
        "$mainMod SHIFT, g, movetoworkspace, 5"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      "bindm" = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      "bindel" = [
        ",XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ",XF86AudioMute,        exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute   @DEFAULT_SINK@ toggle"
      ];

      "bindl" = [
        ", XF86AudioNext,  exec, ${pkgs.playerctl} next"
        ", XF86AudioPause, exec, ${pkgs.playerctl} play-pause"
        ", XF86AudioPlay,  exec, ${pkgs.playerctl} play-pause"
        ", XF86AudioPrev,  exec, ${pkgs.playerctl} previous"
      ];
    };
  };

  config.gtk.font = {
    name = "Sans";
    size = 11;
  };

  config.programs.tofi = {
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
