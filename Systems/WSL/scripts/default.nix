{ pkgs, inputs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };
  config = import ./Config.nix { inherit pkgs; };
  nvim = inputs.nixvim.packages."x86_64-linux".default;
in
{
  environment.systemPackages = [
    rebuild
    config
    nvim
  ];
}
