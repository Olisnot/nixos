{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

		nixvim.url = "github:Olisnot/NixVimConfig";

		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		xremap.url = "github:xremap/nix-flake";
	};

	outputs = { self, nixpkgs, nixpkgsStable, nixos-wsl, ... } @inputs: {
		nixosConfigurations = {
			default = nixpkgs.lib.nixosSystem {
				specialArgs = {inherit inputs;};
				modules = [
					./Systems/Laptop/configuration.nix
						inputs.home-manager.nixosModules.default
				];
			};
			wsl = nixpkgs.lib.nixosSystem {
				specialArgs = {inherit inputs;};
				modules = [
					./Systems/WSL/configuration.nix
						inputs.home-manager.nixosModules.default
						nixos-wsl.nixosModules.default
						{
							system.stateVersion = "24.05";
							wsl.enable = true;
						}
				];
			};
		};
	};
}
