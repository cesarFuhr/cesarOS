{ pkgs, ... }:

{
  # Sway configuration.
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];

    systemd.enable = true;
    swaynag.enable = true;

    config = {
      terminal = "alacritty";
    };
  };
}

