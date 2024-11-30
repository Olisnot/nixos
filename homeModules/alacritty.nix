{ lib, config, ... }:

{
  options = {
    alacrittyConfig.enable = lib.mkEnableOption "Enable alacritty configuration";
  };

  config = lib.mkIf config.alacrittyConfig.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        colors.primary = {
          background = "#1a1b26";
          foreground = "#c0caf5";
        };

        colors.cursor = {
          cursor = "#c0caf5";
          text = "#1a1b26";
        };

        colors.normal = {
          black = "#15161e";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
        };

        colors.bright = {
          black = "#414868";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#c0caf5";
        };

        colors.indexed_colors = {
          index = 16;
          color = "#ff9e64";
        };
      };
    };
  };
}
