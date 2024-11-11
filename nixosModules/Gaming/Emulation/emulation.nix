{ lib, config, pkgs, ... }:

{
  options = {
    gaming.emulation.enable = lib.mkEnableOption "Enable Retroarch and emulation related programs";
  };

  config = lib.mkIf config.gaming.emulation.enable {
    environment.systemPackages = with pkgs; [
      retroarch
      #steam-rom-manager
      #emulationstation-de
    ];
  };
}
