{ pkgs, lib, ... }:

{
  services.hyprpaper.enable = lib.mkForce false;

  stylix = {
    targets.hyprpaper.enable = lib.mkForce false;
    targets.waybar.enable = false;
    targets.helix.enable = true;
    targets.nixcord.enable = false;
    targets.vesktop.enable = false;
    targets.vencord.enable = false;
    targets.btop.enable = true;

    targets.zen-browser.profileNames = [ "Default Profile" ];

    targets.gtk.extraCss = ''
      opacity: 0.8;
    '';

    iconTheme = {
      enable = true;
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy";
    };
  };
}
