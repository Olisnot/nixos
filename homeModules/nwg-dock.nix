{ pkgs, lib, config, ... }:

{
  options.nwg-dock = { enable = lib.mkEnableOption "nwg-dock"; };

  config = lib.mkIf config.enable {
    home.packages = [ pkgs.nwg-dock-hyprland ];
    # home.file."dock_style.css" = {
    #   enable = true;
    #   target = ".config/nwg-dock-hyprland/style.css";
    #   text = /* css */ ''
    #   '';
    # };
  };
}
