{
  lib,
  config,
  pkgs,
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

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      noctalia-shell
    ];

    environment.variables = {
      QT_QPA_PLATFORMTHEME = "gtk3";
    };
  };
}
