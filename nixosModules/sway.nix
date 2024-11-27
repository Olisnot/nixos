{ lib, config, ... }:

{
  options = {
    sway.enable = lib.mkEnableOption "Enable Sway Wayland compositor";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };
}
