{ pkgs, inputs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };
  TmuxSessionizer = import ./TmuxSessionizer.nix { inherit pkgs; };

in {
  imports = [ ../../../scripts ];
  environment.systemPackages = [ rebuild TmuxSessionizer ];
}
