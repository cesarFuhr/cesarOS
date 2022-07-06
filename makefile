rebuild:
	sudo nixos-rebuild switch --flake .#CesarOS

dry-build:
	sudo nixos-rebuild dry-build --flake .#CesarOS

update:
	nix flake update

clear:
	sudo nix-collect-garbage -d
