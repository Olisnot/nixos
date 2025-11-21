{ pkgs, lib, ... }:

{
  stylix = {
    targets.waybar.enable = false;

    iconTheme = {
      enable = true;
      package = pkgs.arashi;
      dark = "Arashi";
    };
  };
}
