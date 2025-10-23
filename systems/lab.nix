# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware/lab.nix
  ];
  networking.hostName = "lab"; # Define your hostname.

  # Setting env var to mark this build as lab.
  environment.variables = {
    CESAR_OS_BUILD = "lab";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  system.stateVersion = "25.05";
}
