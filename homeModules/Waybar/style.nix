{ config, ... }:

let colors = config.lib.stylix.colors.withHashtag;
in {
  programs.waybar.style = ''
    * {
      font-family: FiraCode Nerd Font Propo;
    }

    window#waybar {
      background: ${colors.base00};
    }

    .modules-left,
    .modules-right {
      padding-right: 10px;
      padding-left: 10px;
    }

    #workspaces {
      font-size: 8px;
    }

    #clock {
    }

    #clock,
    #tray,
    #mpd,
    #custom-nixos {
      padding-right: 10px;
      padding-left: 10px;
    }

    #workspaces button {
      padding-left: 0px;
      padding-right: 0px;
    }


    #custom-nixos {
      font-size: 14px;
    }
  '';
}
