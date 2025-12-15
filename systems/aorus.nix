{
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware/aorus.nix
  ];

  # Setting env var to mark this build as aorus.
  environment.variables = {
    CESAR_OS_BUILD = "aorus";
  };
  networking.hostName = "aorus"; # Define your hostname.

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
  users.extraGroups.vboxusers.members = [ "cesar" ];

  system.stateVersion = "26.05";
}
