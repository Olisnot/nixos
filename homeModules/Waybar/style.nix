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
      background-color: transparent;
    }

    #workspaces {
      background-color: ${colors.base00};
      font-size: 20px;
      border-radius: 25px;
      margin-left: 10px;
      border: 2px solid ${colors.base02};
    }

    #workspaces button.active {
      background-color: ${colors.base02};
      border-radius: 25px;
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
      border: 2px solid ${colors.base02};
      border-radius: 25px;
    }
    #cpu {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
      background-color: ${colors.base00};
      border: 2px solid ${colors.base02};
      border-radius: 25px;
    }

    #memory {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
      background-color: ${colors.base00};
      border: 2px solid ${colors.base02};
      border-radius: 25px;
    }

    #tray {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
      background-color: ${colors.base00};
      border: 2px solid ${colors.base02};
      border-radius: 25px;
    }

    #custom-power {
      padding-left: 10px;
      padding-right: 15px;
      font-size: 18px;
      background-color: ${colors.base00};
      border: 2px solid ${colors.base02};
      border-radius: 25px;
    }

    #clock {
      padding-right: 10px;
      padding-left: 10px;
      background-color: ${colors.base00};
      border: 2px solid ${colors.base02};
      border-radius: 25px;
    }
'';
}
