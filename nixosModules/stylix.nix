{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/Cloudsnight.jpg";
    polarity = "dark";
    base16Scheme = {
      base00 = "#000000";
      base01 = "#121212";
      base02 = "#222222";
      base03 = "#333333";
      base04 = "#999999";
      base05 = "#c1c1c1";
      base06 = "#999999";
      base07 = "#c1c1c1";
      base08 = "#5f8787";
      base09 = "#aaaaaa";
      base0A = "#556677";
      base0B = "#7799bb";
      base0C = "#aaaaaa";
      base0D = "#888888";
      base0E = "#999999";
      base0F = "#444444";
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
