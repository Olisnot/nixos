{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.wii-gamecube.enable = lib.mkEnableOption "Enable WII and Gamecube emulation";
  };

  config = lib.mkIf config.gaming.emulation.wii-gamecube.enable {
    environment.systemPackages = with pkgs; [ dolphin-emu ];
  };
}
