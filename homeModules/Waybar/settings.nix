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
      modules-right = [ "tray" "battery" "custom/power" ];

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
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "10";
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

      "pulseaudio" = {
        format = "{icon}";
        format-bluetooth = "{icon}";
        format-muted = "";
        format-icons = {
          headphone = "";
          default = ["" ""];
        };
        scroll-step = 1;
        on-click = "pavucontrol";
        ignored-sinks = ["Easy Effects Sink"];
      };
    }
  ];
}
