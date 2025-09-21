{ pkgs, inputs, ... }:

let rebuild = import ./Rebuild.nix { inherit pkgs; };

in {
  imports = [ ../../../scripts ];
  environment.systemPackages = [ rebuild ];
}
