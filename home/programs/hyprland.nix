{ pkgs, ... }:

{
  # Hyprland configuration.
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$mods" = "SUPER";
    };
  };
}
