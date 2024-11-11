{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.playstation2.enable = lib.mkEnableOption "Enable PlayStation 2 emulation";
  };

  config = lib.mkIf config.gaming.emulation.playstation2.enable {
    environment.systemPackages = with pkgs; [ pcsx2 ];
  };
}
