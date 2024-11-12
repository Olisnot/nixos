{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.wii-gamecube.enable = lib.mkEnableOption "Enable WII and Gamecube emulation";
  };

  config = lib.mkIf config.gaming.emulation.wii-gamecube.enable {
    home.packages = with pkgs; [ dolphin-emu ];
  };
}
