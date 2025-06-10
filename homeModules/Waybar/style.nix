{ config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.waybar.style = ''
    window#waybar {
      background-color: ${colors.base00};
      border-left: 2px solid ${colors.base01};
      border-right: 2px solid ${colors.base01};
      border-bottom: 2px solid ${colors.base01};
      border-top: 0px solid transparent; 
      border-bottom-left-radius: 20px;
      border-bottom-right-radius: 20px;
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
      padding-left: 5px;
      padding-right: 10px;
      font-size: 18px;
    }

    #battery {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
    }

    #pulseaudio {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
    }

    #tray {
      padding-right: 10px;
      padding-left: 10px;
      margin-right: 10px;
    }

    #custom-power {
      padding-left: 10px;
      padding-right: 10px;
      font-size: 18px;
    }

    #clock {
      padding-right: 10px;
      padding-left: 10px;
    }
'';
}
