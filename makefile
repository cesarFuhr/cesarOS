rebuild:
	sudo nixos-rebuild switch --flake .#CesarOS

update:
	nix flake update

clear:
	sudo nix-collect-garbage -d
