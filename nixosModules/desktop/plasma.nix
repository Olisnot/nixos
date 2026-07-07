{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.kde.enable = lib.mkEnableOption "Enable kde plasma";

  config = lib.mkIf config.kde.enable {
    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.discover
      kdePackages.kcalc
      kdePackages.kcharselect
      kdePackages.ksystemlog
      wayland-utils
      wl-clipboard
    ];
  };
}
