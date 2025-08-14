{ ... }:

{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 1;
      modules-left = [ "hyprland/window" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ "tray" "clock" "group/power" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        sort-by-number = true;
        current-only = false;
      };

      "hyprland/window" = {
        "format" = "";
        "icon" = true;
        "separate-outputs" = true;
      };

      clock = {
        format = "{:%I:%M %p}";
        tooltip = false;
      };

      tray = {
        icon-size = 20;
        spacing = 10;
      };

      "group/power" = {
        orientation = "horizontal";
        "drawer" = {
          "transition-duration" = 500;
          "children-class" = "not-power";
          "transition-left-to-right" = false;
        };
        modules = [
          "custom/nixos"
          "custom/restart"
          "custom/poweroff"
        ];
      };

      "custom/nixos" = {
        format = "";
        tooltip = false;
      };

      "custom/poweroff" = {
        format = "󰐥";
        on-click = "poweroff";
        tooltip = false;
      };

      "custom/restart" = {
        format = "";
        on-click = "reboot";
        tooltip = false;
      };
    }
  ];
}
