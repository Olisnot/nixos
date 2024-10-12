{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

                nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};

                firefox-addons = {
                  url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
                  inputs.nixpkgs.follows = "nixpkgs";
                };
	};

        outputs = { self, nixpkgs, nixpkgsStable, ... } @inputs: {
		nixosConfigurations.default = nixpkgs.lib.nixosSystem {
			specialArgs = {inherit inputs;};
			modules = [
				./configuration.nix
				inputs.home-manager.nixosModules.default
			];
		};
	};
}
