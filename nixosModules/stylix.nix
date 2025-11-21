{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/11356529.jpg";
    polarity = "dark";
    base16Scheme = {
      # Nord
      # base00 = "#2E3440";
      # base01 = "#3B4252";
      # base02 = "#434C5E";
      # base03 = "#4C566A";
      # base04 = "#D8DEE9";
      # base05 = "#E5E9F0";
      # base06 = "#ECEFF4";
      # base07 = "#8FBCBB";
      # base08 = "#BF616A";
      # base09 = "#D08770";
      # base0A = "#EBCB8B";
      # base0B = "#A3BE8C";
      # base0C = "#88C0D0";
      # base0D = "#81A1C1";
      # base0E = "#B48EAD";
      # base0F = "#5E81AC";

      # Tokyo Night Storm
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
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors-lefthand";
      size = 24;
    };

    targets.plymouth.enable = false;
  };
}
