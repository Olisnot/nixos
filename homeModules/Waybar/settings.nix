{ ... }:

{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 1;
      margin-top = 0;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "cpu" "memory" "battery" "custom/power" ];

      battery = {
        format = " {capacity}%";
        format-charging = ": {capacity}%";
      };

      clock = {
        format = "{:%I:%M %p}";
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "8" = "";
          "9" = "";
          "10" = "";
        };
        sort-by-number = true;
      };

      "tray" = {
        icon-size = 18;
        spacing = 10;
      };

      "custom/power" = {
        format = "";
        on-click = "systemctl poweroff";
        tooltip = false;
      };

      "cpu" = {
        "interval" = 10;
        "format" = "{}% ";
        "max-length" = 10;
      };

      "memory" = {
        "interval" = 30;
        "format" = "{}% ";
        "max-length" = 10;
      };
    }
  ];
}
