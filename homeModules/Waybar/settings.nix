{ ... }:

{
  programs.waybar.settings = [{
    layer = "top";
    position = "top";
    height = 1;
    margin-top = 0;
    modules-left = [ "group/power" ];
    modules-center = [ "hyprland/workspaces" ];
    modules-right = [ "tray" "clock" ];

    clock = {
      format = "{:%I:%M %p}";
      tooltip = false;
    };

    tray = {
      icon-size = 15;
      spacing = 10;
    };

    "group/power" = {
      orientation = "horizontal";
      "drawer" = {
        "transition-duration" = 500;
        "children-class" = "not-power";
        "transition-left-to-right" = true;
      };
      modules = [ "custom/nixos" "custom/restart" "custom/poweroff" ];
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
  }];
}
