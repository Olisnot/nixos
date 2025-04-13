{ lib, config, ...}:

let
  colors = config.lib.stylix.colors.withHashtag;
in
  {
    options = {
      dunst.enable = lib.mkEnableOption "enable dunst notification daemon"; 
    };

    config = lib.mkIf config.dunst.enable {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            follow = "mouse";
            width = 300;
            height = "(0, 300)";
            offset = "(30, 50)";
            origin = "top-right";
            frame_color = "${colors.base01}";
            frame_width = 3;
            corner_radius = 10;
            icon_corner_radius = 10;
            min_icon_size = 32;
            max_icon_size = 64;
            progress_bar_corner_radius = 5;
          };
          urgency_normal = {
            timeout = 10;
          };
        };
      };
    };
  }
