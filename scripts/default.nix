{ pkgs, ... }:

let
  config = import ./Config.nix { inherit pkgs; };
in
{
  environment.systemPackages = [
    config
  ];
}
