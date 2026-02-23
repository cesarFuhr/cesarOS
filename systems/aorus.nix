{
  pkgs,
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

  # VM Ware
  virtualisation.vmware.host = {
    enable = true;
    extraPackages = [ pkgs.vmware-workstation ];
  };

  # AMD GPU monitoring:
  environment.systemPackages =
    let
      p = pkgs;
    in
    [
      p.rocmPackages.rocminfo
      p.rocmPackages.rocm-smi
      p.clinfo
      p.lact
    ];

  services.lact.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };
  services.nextjs-ollama-llm-ui.enable = true;
}
