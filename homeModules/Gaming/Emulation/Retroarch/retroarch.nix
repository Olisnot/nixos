{ lib, config, pkgs, ... }:

{
  options = {
    gaming.emulation.retroarch.enable = lib.mkEnableOption "Enable Retroarch";
  };

  config = lib.mkIf config.gaming.emulation.retroarch.enable {
    home.packages = with pkgs; [ 
      (retroarch-bare.overrideAttrs {
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
          yabause
        ];
      }
      )
    ];
  };
}
