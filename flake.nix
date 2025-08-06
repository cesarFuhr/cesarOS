{
  description = "cesarOS system builds";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
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
      nixos-hardware,
      home-manager,
      notes-script,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        # This drifted a lot from what I am actually using now a days,
        # but I will leave it be.
        virtualbox = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./systems/virtualbox.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar = import ./home/cesar.nix;
            }
          ];
        };

        # Inspiron
        inspiron = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit notes-script;
          };
          modules = [
            ./systems/inspiron.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar = import ./home/cesar.nix;
            }
          ];
        };

        # Vaio
        vaio = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit notes-script;
          };
          modules = [
            ./systems/vaio.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar =
                {
                  lib,
                  ...
                }:
                let
                  displays = {
                    primaryDisplay = "HDMI-A-1";
                    secondaryDisplay = "eDP-1";
                  };
                in
                {
                  imports = [
                    ./home/cesar.nix
                    # With Wayland.
                    ./home/programs/hyprland.nix
                    ./home/programs/waybar.nix
                    ./home/programs/foot.nix
                  ];

                  waybar = displays;
                  hyprland = displays;
                };
            }
          ];
        };

        # Little laboratory, only exisits to keep the main config more stable.
        lab = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./systems/lab.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar =
                { ... }:
                let
                  displays = {
                    primaryDisplay = "HDMI-A-3";
                    secondaryDisplay = "eDP-1";
                  };
                in
                {
                  imports = [
                    ./home/cesar.nix
                    # With Sway.
                    ./home/programs/sway.nix
                    ./home/programs/waybar.nix
                    ./home/programs/foot.nix
                  ];
                  waybar = displays;
                  sway = displays;
                };
            }
          ];
        };

        rogstrix = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit notes-script;
          };
          modules = [
            ./systems/rogstrix.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.cesar =
                  { ... }:
                  let
                    displays = {
                      primaryDisplay = "HDMI-A-3";
                      secondaryDisplay = "eDP-1";
                    };
                  in
                  {
                    imports = [
                      ./home/cesar.nix
                      # With Sway.
                      ./home/programs/hyprland.nix
                      ./home/programs/waybar.nix
                      ./home/programs/foot.nix
                    ];
                    waybar = displays;
                    hyprland = displays;
                  };
              };
            }
          ];
        };
      };
    };
}
