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
    }:
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
                  config,
                  pkgs,
                  lib,
                  ...
                }:
                {
                  imports = [
                    ./home/cesar.nix
                    # With Wayland.
                    ./home/programs/sway.nix
                    ./home/programs/waybar.nix
                    ./home/programs/foot.nix
                  ];

                  programs.alacritty.settings.font.size = lib.mkForce 15;
                };
            }
          ];
        };

        # Currently, is what I am using on a daily basis.
        legion = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit notes-script;
          };
          modules = [
            ./systems/legion.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar =
                { config, pkgs, ... }:
                {
                  imports = [
                    ./home/cesar.nix
                    # With window manager.
                    ./home/programs/awesome/awesome.nix
                    ./home/programs/i3.nix
                    ./home/programs/polybar/polybar.nix
                    ./home/programs/rofi.nix
                  ];
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
                { config, pkgs, ... }:
                {
                  imports = [
                    ./home/cesar.nix
                    # With Sway.
                    ./home/programs/sway.nix
                    ./home/programs/waybar.nix
                    ./home/programs/foot.nix
                  ];
                };
            }
          ];
        };

	rogstrix = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit notes-script; };
          modules = [
            ./systems/rogstrix.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar = { config, pkgs, ... }: {
                imports = [
                  ./home/cesar.nix
                  # With window manager.
                  ./home/programs/i3.nix
                  ./home/programs/polybar/polybar.nix
                  ./home/programs/rofi.nix
                ];
              };
            }
          ];
        };
      };
    };
}
