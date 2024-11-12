{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.three-ds.enable = lib.mkEnableOption "Enable 3DS emulation";
  };

  config = lib.mkIf config.gaming.emulation.three-ds.enable {
    home.packages = with pkgs; [ lime3ds ];
  };
}
