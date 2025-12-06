{ ... }:

{
  programs.waybar.settings = [{
    layer = "top";
    position = "top";
    height = 1;
    modules-left = [ "custom/nixos" ];
    modules-center = [ "hyprland/workspaces" ];
    modules-right = [ "tray" "clock" ];

    "niri/workspaces" = {
      "format" = "{icon}";
      "format-icons" = {
        "browser" = "";
        "discord" = "";
        "chat" = "<b></b>";

        "active" = "";
        "default" = "";
      };
    };

    clock = {
      format = "{:%a %b %d %I:%M%p}";
      tooltip = false;
    };

    tray = {
      icon-size = 12;
      spacing = 8;
    };

    "custom/nixos" = {
      format = "";
      on-click = "power_menu";
      tooltip = false;
    };
  }];
}
