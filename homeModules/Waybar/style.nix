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

    #clock,
    #tray,
    #mpris,
    #custom-nixos {
      padding-right: 10px;
      padding-left: 10px;
    }


    #custom-nixos {
      font-size: 14px;
    }
  '';
}
