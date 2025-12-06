{ pkgs, lib, config, inputs, ... }:

let
  theme = config.theme;
  themeWallpaper = {
    Nord = "${inputs.wallpapers}/nord.jpg";
    Gruvbox = "${inputs.wallpapers}/gruvbox.jpg";
    Catppuccin = "${inputs.wallpapers}/catppuccin.jpg";
    TokyoNight = "${inputs.wallpapers}/tokyo.png";
  };
in {
  options.gtklock.enable = lib.mkEnableOption "Enable GTK lock";
  config = lib.mkIf config.gtklock.enable {
    programs.gtklock = {
      enable = true;
      config = {
        main = {
          idle-hide = true;
          idle-timeout = 10;
          background = themeWallpaper.${theme};
        };
      };
      modules = with pkgs; [
        gtklock-playerctl-module
        gtklock-powerbar-module
        gtklock-userinfo-module
      ];
    };
  };

}
