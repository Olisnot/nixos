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
      modules-right = [ "custom/music"  "tray" "privacy" "battery" "custom/power" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "0";
        };
        sort-by-number = true;
      };

      battery = {
        format = " {capacity}%";
        format-charging = ": {capacity}%";
      };

      clock = {
        format = "{:%I:%M %p}";
        tooltip = false;
      };

      "tray" = {
        icon-size = 18;
        spacing = 10;
      };

      "privacy" = {
        "icon-spacing" = 4;
        "icon-size" = 18;
        "transition-duration" = 250;
        "modules" = [
          {
            "type" = "screenshare";
            "tooltip" = true;
            "tooltip-icon-size" = 24;
          }
          {
            "type" = "audio-out";
            "tooltip" = true;
            "tooltip-icon-size" = 24;
          }
          {
            "type" = "audio-in";
            "tooltip" = true;
            "tooltip-icon-size" = 24;
          }
        ];
      };

      "custom/music" = {
        format = "🎵";
        on-click = "";
        tooltip = false;
      };

      "custom/power" = {
        format = "";
        on-click = "~/start_menu";
        tooltip = false;
      };
    }
  ];
}
