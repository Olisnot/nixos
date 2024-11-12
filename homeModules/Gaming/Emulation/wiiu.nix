{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.wiiu.enable = lib.mkEnableOption "Enable WII U emulation";
  };

  config = lib.mkIf config.gaming.emulation.wiiu.enable {
    home.packages = with pkgs; [ cemu ];
  };
}
