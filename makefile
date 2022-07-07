rebuild:
	sudo nixos-rebuild switch --flake .#cesarOS

dry-build:
	sudo nixos-rebuild dry-build --flake .#cesarOS

update:
	nix flake update

clear:
	sudo nix-collect-garbage -d
