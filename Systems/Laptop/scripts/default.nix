{ pkgs, inputs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };
  ZellijSessionizer = import ./ZellijSessionizer.nix { inherit pkgs; };
  nvim = inputs.nixvim.packages."x86_64-linux".default;
in
{
  imports = [
    ../../../scripts
  ];
  environment.systemPackages = [
    rebuild
    ZellijSessionizer
    nvim
  ];
}
