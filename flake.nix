{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "git+https://codeberg.org/Olisnot/NixVimConfig";

    wallpapers = {
      url = "github:olmods/wallpapers";
      flake = false;
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
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
          inputs.stylix.nixosModules.stylix
          lsfg-vk-flake.nixosModules.default
        ];
      };
      steamdeck = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./Systems/SteamDeck/configuration.nix
          ({ ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          inputs.home-manager.nixosModules.default
          inputs.stylix.nixosModules.stylix
          lsfg-vk-flake.nixosModules.default
        ];
      };
    };
  };
}
