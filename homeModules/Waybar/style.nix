{ config, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.waybar.style = ''
    * {
      font-family: FiraCode Nerd Font Propo;
      font-size: 16px;
    }

    window#waybar {
      background: ${colors.base00};
      box-shadow: 0 4px 8px rgba(76, 76, 76, 0.2);
      border-bottom-left-radius: 20px;
      border-bottom-right-radius: 20px;
    }

    .modules-left,
    .modules-right {
      padding-right: 10px;
      padding-left: 10px;
    }

    #workspaces {
      padding-left: 5px;
      padding-right: 5px;
    }

    #custom-poweroff,
    #custom-restart,
    #custom-nixos,
    #workspaces button:hover {
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
      margin: 5px;
      padding-right: 10px;
      padding-left: 10px;
      background: ${colors.base02};
      border-radius: 20px;
    }
'';
}
