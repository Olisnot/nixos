{ lib, config, pkgs, ... }:

{
  options = {
    gaming.emulation.retroarch.enable = lib.mkEnableOption "Enable Retroarch";
  };

  config = lib.mkIf config.gaming.emulation.retroarch.enable {
    environment.systemPackages = with pkgs; [ 
      (retroarch.override {
        cores = with libretro; [
          fceumm
          snes9x
          gambatte
          mgba
          melonds
          mupen64plus
          ppsspp
          blastem
          flycast
          yabuse
        ];
      }
      )
    ];
  };
}
