{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:olmods/wallpapers";
      flake = false;
    };
  };

  outputs =
    { nixpkgsStable, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      overlay-stable = final: prev: {
        stable = import nixpkgsStable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations = {
        legiony540 = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./Systems/LegionY540/configuration.nix
            (
              { ... }:
              {
                nixpkgs.overlays = [
                  overlay-stable
                  nur.overlays.default
                ];
              }
            )
            inputs.stylix.nixosModules.stylix
          ];
        };
      };
    };
}
