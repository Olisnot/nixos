{ ... }:

{
  programs.waybar.settings = [{
    layer = "top";
    position = "top";
    height = 1;
    margin-top = 10;
    margin-left = 10;
    margin-right = 10;
    modules-left = [ "mpd" ];
    modules-center = [ "hyprland/workspaces" ];
    modules-right = [ "tray" "clock" ];

    "hyprland/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "active" = "";
        "default" = "";
      };
      "sort-by-number" = true;
    };

    clock = {
      format = "{%A %b %d :%I:%M %p}";
      tooltip = false;
    };

    tray = {
      icon-size = 15;
      spacing = 10;
    };

    "mpd" = {
      format = "{stateIcon} {album} - {title}";
      format-disconnected = "Disconnected ";
      format-stopped = "Stopped ";
      album-len = 20;
      title-len = 20;
      interval = 10;
      state-icons = {
        paused = "";
        playing = "";
      };
      tooltip-format = "{artist} - {album} - {title}";
      tooltip-format-disconnected = "MPD (disconnected)";
      on-click = "rmpc togglepause";
      on-click-right = "rmpc next";
    };

    "group/power" = {
      orientation = "horizontal";
      "drawer" = {
        "transition-duration" = 500;
        "children-class" = "not-power";
        "transition-left-to-right" = true;
      };
      modules = [ "custom/nixos" "custom/poweroff" "custom/restart" ];
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
