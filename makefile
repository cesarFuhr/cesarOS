rebuild:
	sudo nixos-rebuild switch --flake .#${CESAR_OS_BUILD}

dry-build:
	sudo nixos-rebuild dry-build --flake .#${CESAR_OS_BUILD}

dev-nvim:
	bash ./home/programs/nvim/dev.sh

update:
	nix flake update

trim:
	sudo bash ./trim-gens.sh

clean:
	nix-store --gc
	nix-store --optimize
