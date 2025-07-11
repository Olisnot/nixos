{ ... }:

{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 1;
      width = 1920;
      margin-top = 0;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "custom/power" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        sort-by-number = true;
        current-only = false;
      };

      clock = {
        format = "{:%I:%M %p}";
        tooltip = false;
      };

      tray = {
        icon-size = 20;
        spacing = 10;
      };

      "custom/power" = {
        format = "";
        on-click = "~/start_menu";
        tooltip = false;
      };
    }
  ];
}
