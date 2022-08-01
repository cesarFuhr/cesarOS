rebuild:
	sudo nixos-rebuild switch --flake .#${CESAR_OS_BUILD}

dry-build:
	sudo nixos-rebuild dry-build --flake .#${CESAR_OS_BUILD}

update:
	nix flake update

trim:
	sudo bash ./trim-gens.sh
