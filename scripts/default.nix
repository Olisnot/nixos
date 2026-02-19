{ pkgs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };

in {
  environment.systemPackages = [ rebuild ];
}
