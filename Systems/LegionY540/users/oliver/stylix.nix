{ pkgs, lib, ... }:

{
  stylix = {
    targets.waybar.enable = false;

    iconTheme = {
      enable = true;
      package = pkgs.nordzy-icon-theme;
      dark = "Nordzy";
    };
  };
}
