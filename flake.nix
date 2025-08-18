{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:olmods/wallpapers";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgsStable, lsfg-vk-flake, ... } @inputs:
  let
    system = "x86_64-linux";
    overlay-stable = final: prev: { stable = import nixpkgsStable { inherit system; config.allowUnfree = true;}; };
  in
  {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./Systems/Laptop/configuration.nix
          ({ ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          inputs.home-manager.nixosModules.default
          lsfg-vk-flake.nixosModules.default
        ];
      };
    };
  };
}
