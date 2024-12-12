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
      primaryMonitor = lib.mkOption {
        default = "missingMonitor";
        type = lib.types.str;
      };
      secondaryMonitor = lib.mkOption {
        default = "missingMonitor";
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

    extraConfig =
      builtins.replaceStrings
        [ "{{primaryMonitor}}" "{{secondaryMonitor}}" ]
        [ cfg.primaryMonitor cfg.secondaryMonitor ]
        (builtins.readFile (builtins.toString ./config.ini));
  };
}
