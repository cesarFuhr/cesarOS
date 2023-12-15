{
  description = "cesarOS system builds";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, ... }:
    let
      system = "x86_64-linux";

      pgks = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        virtualbox = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./system/virtualbox/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar = import ./home/home.nix;
            }
          ];
        };

        legion = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            #nixos-hardware.nixosModules.lenovo-legion-15ach6
            ./system/legion/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar = import ./home/home.nix;
            }
          ];
        };
      };
    };
}
