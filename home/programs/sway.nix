{ pkgs, ... }:

{
  # Sway configuration.
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    systemd.enable = true;
    swaynag.enable = true;

    config = {
      terminal = "alacritty";
    };
  };
}

