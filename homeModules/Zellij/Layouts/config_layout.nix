{ lib, config, ... }:

{
  config = lib.mkIf config.zellij.enable {
    home.file."config_layout.kdl" = {
      enable = true;
      target = "/home/oliver/.config/zellij/Layouts/config_layout.kdl";
      text = ''
      layout {
        tab name="Config" {
          pane edit="/nixos/"
          pane size=1 borderless=true {
            plugin location="zellij:compact-bar"
          }
        }
      }
      '';
    };
  };
}
