{ pkgs, inputs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };
  filen-backup = import ./FilenBackup.nix { inherit pkgs; };

in {
  imports = [ ../../../scripts ];
  environment.systemPackages = [ rebuild filen-backup ];
}
