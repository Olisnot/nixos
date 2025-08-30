{ config, pkgs, ... }:

let colors = config.lib.stylix.colors.withHashtag;
in {
  programs.waybar.style = ''
    * {
      font-family: FiraCode Nerd Font Propo;
    }

    window#waybar {
      background: rgba(33, 33, 33, 0.8);
      box-shadow: 0 4px 8px rgba(76, 76, 76, 0.2);
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
