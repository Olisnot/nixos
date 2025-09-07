{ config, lib, pkgs, ... }:

{
  options = { wofi.enable = lib.mkEnableOption "wofi"; };

  config = lib.mkIf config.wofi.enable {
    programs.wofi = {
      enable = true;
      settings = {
        allow_images = true;
        hide_scroll = true;
        no_actions = false;
        width = "30%";
        insensitive = true;
      };
    };
    home.packages = [ (import ./powerScript.nix { inherit pkgs; }) ];
  };
}
