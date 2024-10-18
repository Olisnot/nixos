{ ... }:

{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 1;
      margin-top = 5;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "battery" "group/power" ];

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
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "8" = "";
          "9" = "";
          "10" = "";
        };
        sort-by-number = true;
      };

      "tray" = {
        icon-size = 18;
        spacing = 10;
      };

      "group/power" = {
        drawer = {
          transition-duration = 500;
          children-class = "not-power";
          transition-left-to-right = false;
        };
        orientation = "horizontal";
        modules = [
          "custom/power"
          "custom/logout"
          "custom/suspend"
          "custom/reboot"
        ];
      };

      "custom/power" = {
        format = "";
        on-click = "systemctl poweroff";
        tooltip = false;
      };

      "custom/reboot" = {
        format = "";
        on-click = "systemctl reboot";
        tooltip = false;
      };

      "custom/suspend" = {
        format = "";
        on-click = "systemctl suspend";
        tooltip = false;
      };

      "custom/logout" = {
        format = "";
        on-click = "hyprctl dispatch exit";
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
