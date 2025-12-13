{ ... }:

{
  programs.waybar.settings = [{
    layer = "top";
    position = "top";
    height = 1;
    modules-left = [ "custom/nixos" ];
    modules-center = [ "niri/workspaces" ];
    modules-right = [ "tray" "clock" ];

    "niri/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "default" = "";
        "active"= "";
      };
      "sort-by-number" = true;
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
