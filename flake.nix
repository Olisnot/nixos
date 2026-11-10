{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.05";
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
      packages.x86_64-linux.wireguard-enroll = import ./scripts/WireguardEnroll.nix {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };

      checks.x86_64-linux.olympus-proxy = import ./Systems/Olympus/proxy-check.nix {
        host = inputs.self.nixosConfigurations.olympus;
      };
      checks.x86_64-linux.wireguard-enroll = import ./scripts/WireguardEnrollCheck.nix {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        enroll = inputs.self.packages.x86_64-linux.wireguard-enroll;
      };
      checks.x86_64-linux.wireguard-mobile = import ./Systems/Olympus/wireguard-mobile-check.nix {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };
      checks.x86_64-linux.olympus-media = import ./Systems/Olympus/media/check.nix {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };
      checks.x86_64-linux.qbittorrent-mullvad = import ./Systems/Olympus/media/mullvad-check.nix {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };

      nixosConfigurations = {
        olympus = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inputs.disko.nixosModules.disko
            ./Systems/Olympus/configuration.nix
          ];
        };

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
