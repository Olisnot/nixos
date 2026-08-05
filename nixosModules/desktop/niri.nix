{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.niri.enable = lib.mkEnableOption "use niri as wayland compositor";

  config = lib.mkIf config.niri.enable {
    programs.niri.enable = true;

    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      noctalia-shell
    ];

    environment.variables = {
      QT_QPA_PLATFORMTHEME = "gtk3";
    };
  };
}
