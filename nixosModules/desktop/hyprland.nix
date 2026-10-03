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
      withUWSM = true;
    };

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.hypridle.enable = true;

    environment.systemPackages = with pkgs; [
      hyprlock
      waybar
      awww
      mako
      bemenu
    ];

    environment.variables = {
      QT_QPA_PLATFORMTHEME = "gtk3";
    };
  };
}
