{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";

    wallpapers = {
      url = "github:olmods/wallpapers";
      flake = false;
    };
  };

  outputs =
    { nixpkgsStable, ... }@inputs:
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
                ];
              }
            )
          ];
        };
      };
    };
}
