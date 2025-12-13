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
      background: ${colors.base01};
      border-radius: 1rem;
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

    #workspaces button.active {
      background: ${colors.base06};
      padding-left: 20px;
      padding-right: 20px;
    }


    #custom-nixos {
      font-size: 14px;
    }
  '';
}
