{ pkgs, ... }:

{
  # Sway configuration.
  wayland.windowManager.sway = {
    extraOptions = [ "--unsupported-gpu" ];
  };
}

