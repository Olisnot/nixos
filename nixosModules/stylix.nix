{ pkgs, inputs, config, lib, ... }:

let
  inherit (lib) mkOption types;

  theme = config.theme;

  base16Theme = {
    Nord = {
      # Nord (Winter)
      base00 = "#2E3440";
      base01 = "#3B4252";
      base02 = "#434C5E";
      base03 = "#4C566A";
      base04 = "#D8DEE9";
      base05 = "#E5E9F0";
      base06 = "#ECEFF4";
      base07 = "#8FBCBB";
      base08 = "#BF616A";
      base09 = "#D08770";
      base0A = "#EBCB8B";
      base0B = "#A3BE8C";
      base0C = "#88C0D0";
      base0D = "#81A1C1";
      base0E = "#B48EAD";
      base0F = "#5E81AC";
    };
    Gruvbox = {
      # Gruvbox Material Dark Hard (Summer)
      base00 = "#202020";
      base01 = "#2a2827";
      base02 = "#504945";
      base03 = "#5a524c";
      base04 = "#bdae93";
      base05 = "#ddc7a1";
      base06 = "#ebdbb2";
      base07 = "#fbf1c7";
      base08 = "#ea6962";
      base09 = "#e78a4e";
      base0A = "#d8a657";
      base0B = "#a9b665";
      base0C = "#89b482";
      base0D = "#7daea3";
      base0E = "#d3869b";
      base0F = "#bd6f3e";
    };
    Catppuccin = {
      # Catppuccin Frappe (Spring)
      base00 = "#303446";
      base01 = "#292c3c";
      base02 = "#414559";
      base03 = "#51576d";
      base04 = "#626880";
      base05 = "#c6d0f5";
      base06 = "#f2d5cf";
      base07 = "#babbf1";
      base08 = "#e78284";
      base09 = "#ef9f76";
      base0A = "#e5c890";
      base0B = "#a6d189";
      base0C = "#81c8be";
      base0D = "#8caaee";
      base0E = "#ca9ee6";
      base0F = "#eebebe";
    };
    TokyoNight = {
      # Tokyo Night Storm (Autumn)
      base00 = "#24283B";
      base01 = "#16161E";
      base02 = "#343A52";
      base03 = "#444B6A";
      base04 = "#787C99";
      base05 = "#A9B1D6";
      base06 = "#CBCCD1";
      base07 = "#D5D6DB";
      base08 = "#C0CAF5";
      base09 = "#A9B1D6";
      base0A = "#0DB9D7";
      base0B = "#9ECE6A";
      base0C = "#B4F9F8";
      base0D = "#2AC3DE";
      base0E = "#BB9AF7";
      base0F = "#F7768E";
    };
  };

  themeWallpaper = {
    Nord = "${inputs.wallpapers}/nord.jpg";
    Gruvbox = "${inputs.wallpapers}/gruvbox.jpg";
    Catppuccin = "${inputs.wallpapers}/catppuccin.jpg";
    TokyoNight = "${inputs.wallpapers}/tokyo.png";
  };

  themeCursor = {
    Nord = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Nord";
    };
    Gruvbox = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Gruvbox";
    };
    Catppuccin = {
      package = pkgs.catppuccin-cursors;
      name = "Catppuccin frappe DARK";
    };
    TokyoNight = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Palenight";
    };
  };
in {
  options = {
    theme = lib.mkOption {
      type = types.enum [ "Nord" "Gruvbox" "Catppuccin" "TokyoNight" ];
      default = "Nord";
      description = "Select a theme";
    };
  };

  config = {
    stylix = {
      enable = true;
      image = themeWallpaper.${theme};
      polarity = "dark";
      base16Scheme = base16Theme.${theme};

      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        monospace = {
          package = pkgs.fira-code;
          name = "FiraCode Nerd Font Propo";
        };

        sizes = {
          applications = 10;
          terminal = 10;
          desktop = 10;
          popups = 10;
        };
      };

      cursor = {
        package = themeCursor.package;
        name = themeCursor.name;
        size = 24;
      };

      targets.plymouth.enable = false;
    };
  };
}
