{ ... }:

{
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 1;
      margin-top = 0;
      modules-left = [ ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "pulseaudio"  "battery" "custom/power" ];

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

      pulseaudio = {
        format = "{icon}  {volume}%";
        "format-muted" = "";
        "format-icons" = {
          "headphone" = "";
          "default" = ["" ""];
        };
        scroll-step = 1;
        on-click = "pwvucontrol";
        ignored-sinks = ["Easy Effects Sink"];
      };

      "custom/power" = {
        format = "";
        on-click = "~/start_menu";
        tooltip = false;
      };
    }
  ];
}
