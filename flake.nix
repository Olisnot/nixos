{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixarr.url = "github:nix-media-server/nixarr";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    wallpapers = {
      url = "git+https://codeberg.org/Olisnot/Wallpapers.git";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgsStable,
      nixarr,
      hermes-agent,
      ...
    }@inputs:
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
        zeus = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./Systems/Zeus/configuration.nix
            hermes-agent.nixosModules.default
            nixarr.nixosModules.default
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
