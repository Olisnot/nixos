{ pkgs, inputs, ... }:

let
  rebuild = import ./scripts/Rebuild.nix { inherit pkgs; };
  config = import ./scripts/Config.nix { inherit pkgs; };
  nvim = inputs.nixvim.packages."x86_64-linux".default;
in
{
  environment.systemPackages = [
    rebuild
    config
    nvim
  ];
}
