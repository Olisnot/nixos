{ pkgs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };
  wireguardEnroll = import ./WireguardEnroll.nix { inherit pkgs; };

in
{
  environment.systemPackages = [
    rebuild
    wireguardEnroll
  ];
}
