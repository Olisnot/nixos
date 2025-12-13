{ ... }:

{
  programs.waybar.settings = [{
    layer = "top";
    position = "top";
    height = 1;
    modules-left = [ "custom/nixos" "mpris" ];
    modules-center = [];
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
      player-icons = {
        default = "▶";
      };
      status-icons = {
        paused = "⏸";
        playing = "▶";
      };
    };

    "custom/nixos" = {
      format = "";
      on-click = "power_menu";
      tooltip = false;
    };
  }];
}
