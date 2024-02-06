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

  outputs = { nixpkgs, home-manager, notes-script, ... }:
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
              home-manager.users.cesar = import ./home/home.nix;
            }
          ];
        };

        # Currently, is what I am using on a daily basis.
        legion = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit notes-script; };
          modules = [
            ./systems/legion.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cesar = import ./home/home.nix;
            }
          ];
        };

        # Little laboratory, only exisits to keed the main config more stable.
        lab = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./systems/lab.nix
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
