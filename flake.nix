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

    wallpapers = {
      url = "github:olmods/wallpapers";
      flake = false;
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixvim.url = "github:Olisnot/NixVimConfig";

    nur.url = "github:nix-community/nur";

    xremap.url = "github:xremap/nix-flake";

    zen-browser.url = "github:MarceColl/zen-browser-flake";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgsStable, nixos-wsl, ... } @inputs: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./Systems/Laptop/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.stylix.nixosModules.stylix
          inputs.spicetify-nix.nixosModules.default
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
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
