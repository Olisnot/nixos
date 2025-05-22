{ config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.waybar.style = ''
    window#waybar {
      background-color: transparent;
    }

    .modules-left {
      padding-left: 10px;
      padding-right: 10px;
    }

    .modules-right {
      padding-right: 10px;
      padding-left: 10px;
    }

    #workspaces {
      background-color: ${colors.base00};
      border: 1px solid ${colors.base02};
      border-radius: 10px;
      padding-left: 5px;
      padding-right: 10px;
      font-size: 18px;
    }

    #battery {
      background-color: ${colors.base00};
      border: 1px solid ${colors.base02};
      border-radius: 10px;
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
    }

    #tray {
      background-color: ${colors.base00};
      border: 1px solid ${colors.base02};
      border-radius: 10px;
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
    }

    #mpd {
      background-color: ${colors.base00};
      border: 1px solid ${colors.base02};
      border-radius: 10px;
      padding-right: 10px;
      padding-left: 10px;
      margin-left: 10px;
    }

    #custom-power {
      background-color: ${colors.base00};
      border: 1px solid ${colors.base02};
      border-radius: 10px;
      padding-left: 10px;
      padding-right: 10px;
      font-size: 18px;
    }

    #clock {
      background-color: ${colors.base00};
      border: 1px solid ${colors.base02};
      border-radius: 10px;
      padding-right: 10px;
      padding-left: 10px;
    }
'';
}
