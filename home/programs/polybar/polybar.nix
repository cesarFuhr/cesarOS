{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.polybar;
in

{
  options = {
    polybar = {
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

  config.services.polybar = {
    enable = true;
    script = ''
      ${pkgs.polybar}/bin/polybar --reload internal &
      ${pkgs.polybar}/bin/polybar --reload external &
    '';

    package = pkgs.polybar.override {
      pulseSupport = true;
    };

    extraConfig =
      builtins.replaceStrings
        [ "{{primaryDisplay}}" "{{secondaryDisplay}}" ]
        [ cfg.primaryDisplay cfg.secondaryDisplay ]
        (builtins.readFile (builtins.toString ./config.ini));
  };
}
