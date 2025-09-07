{ config, ... }:

let colors = config.lib.stylix.colors.withHashtag;
in {
  programs.waybar.style = ''
    * {
      font-family: FiraCode Nerd Font Propo;
    }

    window#waybar {
      background: ${colors.base00};
      border-radius: 25px;
    }

    .modules-left,
    .modules-right {
      padding-right: 10px;
      padding-left: 10px;
    }

    #workspaces {
      font-size: 12px;
    }

    #custom-poweroff:hover,
    #custom-restart:hover,
    #custom-nixos:hover {
      background: ${colors.base03};
      border-radius: 20px;
    }

    #clock {
      font-size: 14px;
    }

    #clock,
    #tray,
    #mpd,
    #group-power,
    #custom-poweroff,
    #custom-restart,
    #custom-nixos,
    #workspaces {
      padding-right: 10px;
      padding-left: 10px;
    }

    #group-power,
    #custom-poweroff,
    #custom-restart,
    #custom-nixos {
      font-size: 16px;
    }
  '';
}
