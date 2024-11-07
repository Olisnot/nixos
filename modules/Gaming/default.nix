{ lib, config, pkgs, ... }:

{
  options = {
    gaming.enable = lib.mkEnableOption "Enable gaming settings and applications";
  };
  config = lib.mkIf config.gaming.enable {
    imports =
      [ 
        ./steam.nix
        ./aagl.nix
      ];
      programs.gamemode.enable = true;
      hardware.xpadneo.enable = true;

      environment.systemPackages = with pkgs; [
        lutris
        steam-run
        heroic
        protonup-qt
        mangohud

                        #Emulation
                        retroarch
                        rpcs3
                      ];
                    };
                  }
