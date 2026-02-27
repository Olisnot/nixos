{
  lib,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  options.niri.enable = lib.mkEnableOption "use niri as wayland compositor";

  config = lib.mkIf config.niri.enable {
    programs.niri.enable = true;

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
