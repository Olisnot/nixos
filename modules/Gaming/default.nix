{ lib, config, pkgs, ... }:

{
  imports =
    [ 
      ./steam.nix
      ./aagl.nix
    ];

    options = {
      gaming.enable = lib.mkEnableOption "Enable gaming settings and applications";
    };
    config = lib.mkIf config.gaming.enable {
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
                      aagl.enable = lib.mkDefault true;
                      steam.setup.enable = lib.mkDefault true;
                    };
                  }
