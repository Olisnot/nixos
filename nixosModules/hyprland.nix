{
  lib,
  config,
  inputs,
  ...
}:

{
  options = {
    hyprland.enable = lib.mkEnableOption "Enable Hyprland Wayland compositor";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    services.noctalia-shell.enable = true;

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    environment.variables = {
      QT_QPA_PLATFORMTHEME = "gtk3";
    };
  };
}
