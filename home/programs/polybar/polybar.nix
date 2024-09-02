{ pkgs, ... }:

{
  services.polybar = {
    enable = true;
    script = ''
        ${pkgs.polybar}/bin/polybar --reload internal &
        ${pkgs.polybar}/bin/polybar --reload external &
    '';

    config = ./config.ini;
  };
}

