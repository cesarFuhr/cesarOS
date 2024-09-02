{ pkgs, ... }:

{
  services.polybar = {
    enable = true;
    script = ''
      for m in $(${pkgs.polybar}/bin/polybar --list-monitors | cut -d":" -f1); do
        MONITOR=$m ${pkgs.polybar}/bin/polybar --reload bar &
      done
    '';

    config = ./config.ini;
  };
}

