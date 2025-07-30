{ lib, config, ... }:

{
  imports = [
    ./settings.nix
    ./style.nix
  ];

  options = {
    waybarConfig.enable = lib.mkEnableOption "Enable waybar config";
  };

  config = lib.mkIf config.waybarConfig.enable {
    programs.waybar.enable = true;
  };
}
