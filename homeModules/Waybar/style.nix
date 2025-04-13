{ config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.waybar.style = ''
    * {
      font-weight: bold;
      font-size: 14px;
    }

    window#waybar {
      background-color: ${colors.base00};
    }

    #workspaces {
      background-color: ${colors.base00};
      font-size: 20px;
      margin-left: 10px;
    }

    #workspaces button.active {
      background-color: ${colors.base02};
    }

    .modules-left {
      padding-left: 10px;
      padding-right: 10px;
    }

    .modules-right {
      padding-right: 10px;
      padding-left: 10px;
    }

    #battery {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
      background-color: ${colors.base00};
    }

    #mpris {
      border-radius: 25px;
      border: 2px solid ${colors.base02};
      padding-right: 10px;
      padding-left: 10px;
    }

    #tray {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
    }

    #custom-power {
      padding-left: 10px;
      padding-right: 15px;
      margin-right: 10px;
      font-size: 18px;
    }

    #clock {
      padding-right: 10px;
      padding-left: 10px;
    }
'';
}
