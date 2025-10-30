{ pkgs, lib, ... }:

{
  services.hyprpaper.enable = lib.mkForce false;

  stylix = {
    targets.hyprpaper.enable = lib.mkForce false;
    targets.waybar.enable = false;

    iconTheme = {
      enable = true;
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy";
    };
  };
}
