# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  notes-script,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware/vaio.nix
  ];

  # Setting env var to mark this build as lab.
  environment.variables = {
    CESAR_OS_BUILD = "vaio";
  };

  networking.hostName = "vaio"; # Define your hostname.

  # Touchpads
  services.libinput.enable = true;

  # etc settings
  environment.etc = {
    # keychron K3 - mediakeys
    "modprobe.d/hid_apple.conf".text = ''
      options hid_apple fnmode=1
    '';
  };

  system.stateVersion = "25.05";
}
