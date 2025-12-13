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

    #window {
      background: ${colors.base01};
      border-radius: 1rem;
      padding-top: 2px;
      padding-bottom: 2px;
      padding-left: 5px;
      padding-right: 5px;
    }

    #custom-nixos {
      font-size: 14px;
    }
  '';
}
