{ ... }:

{
  programs.waybar.settings = [{
    layer = "top";
    position = "top";
    height = 1;
    modules-left = [ "custom/nixos" "mpris" ];
    modules-center = [ "niri/window" ];
    modules-right = [ "tray" "clock" ];

    clock = {
      format = "{:%a %b %d %I:%M%p}";
      tooltip = false;
    };

    tray = {
      icon-size = 12;
      spacing = 8;
    };

    mpris = {
      format = "{status_icon} {title}";
      title-len = 30;
      player-icons = {
        default = "▶";
      };
      status-icons = {
        paused = "⏸";
        playing = "▶";
      };
    };

    "niri/window" = {
      format = "{title}";
      icon = true;
      rewrite = {
        "(.*) - Chromium" = "Chromium";
        "(.*) - YouTube Music" = "YouTube Music";
      };
    };

    "custom/nixos" = {
      format = "";
      on-click = "power_menu";
      tooltip = false;
    };
  }];
}
