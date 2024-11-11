{ pkgs, lib, config, ... }:

{
  options = {
    gaming.emulation.playstation3.enable = lib.mkEnableOption "Enable PlayStation 3 emulation";
  };

  config = lib.mkIf config.gaming.emulation.playstation3.enable {
    environment.systemPackages = with pkgs; [ rpcs3 ];
  };
}
