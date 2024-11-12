{ lib, config, pkgs, ... }:

{
  options = {
    gaming.emulation.emulationstation.enable = lib.mkEnableOption "Enable EmulationStation-de";
  };

  config = lib.mkIf config.gaming.emulation.emulationstation.enable {
    home.packages = with pkgs; [ emulationstation-de ];
    nixpkgs.config.permittedInsecurePackages = [ "freeimage-unstable-2021-11-01" ];
  };
}
