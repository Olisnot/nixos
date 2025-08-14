{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/Cloudsnight.jpg";
    polarity = "dark";
    base16Scheme = {
      base00 = "#0d0c0ccc";
      base01 = "#1D1C19cc";
      base02 = "#282727cc";
      base03 = "#737c73cc";
      base04 = "#a6a69c";
      base05 = "#c5c9c5";
      base06 = "#7a8382";
      base07 = "#c5c9c5";
      base08 = "#c4746e";
      base09 = "#b98d7b";
      base0A = "#c4b28a";
      base0B = "#87a987";
      base0C = "#8ea4a2";
      base0D = "#8ba4b0";
      base0E = "#8992a7";
      base0F = "#a292a3";
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
        terminal = 12;
        desktop = 10; 
        popups = 10; 
      };
    };

    cursor = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors";
      size = 24;
    };
  };
}
