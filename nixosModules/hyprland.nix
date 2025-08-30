{ lib, config, ... }:

{
  options = {
    hyprland.enable = lib.mkEnableOption "Enable Hyprland Wayland compositor";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    programs.hyprlock.enable = true;
  };
}
