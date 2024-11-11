{ lib, config, pkgs, ... }:

{
  options = {
    gaming.emulation.enable = lib.mkEnableOption "Enable emulation related programs";
  };

  config = lib.mkIf config.gaming.emulation.enable {
    environment.systemPackages = with pkgs; [ steam-rom-manager ];
  };
}
