{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.playstation.enable = lib.mkEnableOption "Enable PlayStation emulation";
  };

  config = lib.mkIf config.gaming.emulation.playstation.enable {
    home.packages = with pkgs; [ duckstation ];
  };
}
