{
  description = "cesarOS system builds";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    notes-script = {
      url = "github:cesarFuhr/notes-script";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      notes-script,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        vaio = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit notes-script;
          };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./systems/common.nix
            ./systems/vaio.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar =
                { pkgs, ... }:
                {
                  imports = [
                    ./home/cesar.nix
                    # With Wayland.
                    ./home/programs/sway.nix
                    ./home/programs/waybar.nix
                    ./home/programs/foot.nix
                  ];
                  cesarOS = {
                    terminal.package = pkgs.foot;
                    displays = {
                      "eDP-1" = {
                        resolution = "1920x1080";
                        position = "0,0";
                        frequency = "60.001";
                        primary = true;
                        scale = 1.0;
                      };
                    };
                  };
                };
            }
          ];
        };

        aorus = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit notes-script;
          };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./systems/common.nix
            ./systems/aorus.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.cesar =
                  { pkgs, ... }:
                  {
                    imports = [
                      ./home/cesar.nix
                      # With Sway.
                      ./home/programs/sway.nix
                      ./home/programs/waybar.nix
                      ./home/programs/foot.nix
                      ./home/programs/ghostty.nix
                    ];
                    cesarOS = {
                      terminal.package = pkgs.foot;
                      displays = {
                        "DP-1" = {
                          resolution = "3840x2160";
                          position = "1920,0";
                          frequency = "60.000";
                          primary = true;
                          scale = 1.0;
                        };

                        "DP-2" = {
                          resolution = "2560x1440";
                          position = "5760,0";
                          frequency = "179.999";
                          transform = "90";
                          primary = false;
                          scale = 1.0;
                        };
                      };
                    };
                  };
              };
            }
          ];
        };
      };
    };
}
