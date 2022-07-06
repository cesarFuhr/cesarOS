rebuild:
	sudo nixos-rebuild switch --flake .#CesarOS

dry-build:
	sudo nixos-rebuild dry-build --show-trace --flake .#CesarOS

update:
	nix flake update

clear:
	sudo nix-collect-garbage -d
