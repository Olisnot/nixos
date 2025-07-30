{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.ds.enable = lib.mkEnableOption "Enable DS emulation";
  };

  config = lib.mkIf config.gaming.emulation.ds.enable {
    home.packages = with pkgs; [ melonDS ];
  };
}
