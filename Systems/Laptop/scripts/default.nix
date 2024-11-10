{ pkgs, inputs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };
  Obsidian = import ./Obsidian.nix { inherit pkgs; };
  nvim = inputs.nixvim.packages."x86_64-linux".default;
in
{
  imports = [
    ../../../scripts
  ];
  environment.systemPackages = [
    rebuild
    Obsidian
    nvim
  ];
}
