{ ... }:

{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 1;
      margin-top = 5;
      modules-left = [ "niri/workspaces" "mpd" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "battery" "custom/power" ];

      "niri/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "media" = "";
          "browser" = "";
          "terminal" = "";
          "obsidian" = "";
          "gaming" = "";
          "social" = "";
          "extern-monitor" = "";
        };
        sort-by-number = true;
        current-only = true;
      };

      battery = {
        format = " {capacity}%";
        format-charging = ": {capacity}%";
      };

      clock = {
        format = "{:%I:%M %p}";
        tooltip = false;
      };

      tray = {
        icon-size = 18;
        spacing = 10;
      };

      mpd = {
        format = "{stateIcon} - {album} - {title}";
        format-disconnected = "Disconnected ";
        format-stopped = "Stopped ";
        interval = 10;
        on-click = "rmpc togglepause";
        state-icons = {
          paused = "";
          playing = "";
        };
        tooltip-format = "MPD (connected)";
        tooltip-format-disconnected = "MPD (disconnected)";
      };

      "custom/power" = {
        format = "";
        on-click = "~/start_menu";
        tooltip = false;
      };
    }
  ];
}
