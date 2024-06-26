{ pkgs, ... }:

{
  # Sway configuration.
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    systemd.enable = true;
    swaynag.enable = true;

    config = {
      modifier = "Mod4";
      terminal = "alacritty";

      input = {
        "type:keyboard" = {
          xkb_options = "caps:ctrl_modifier";
        };
      };
    };
  };
}

