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

    environment.systemPackages = with pkgs; [
      waybar
      xwayland-satellite
      swww
    ];
  };
}
