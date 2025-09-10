{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/clay-banks-u27Rrbs9Dwc-unsplash.jpg";
    polarity = "light";
    base16Scheme = {
      base00 = "#f9f5d7";
      base01 = "#fbf1c7";
      base02 = "#e0cfa9";
      base03 = "#a89984";
      base04 = "#c9b99a";
      base05 = "#654735";
      base06 = "#3c3836";
      base07 = "#282828";
      base08 = "#c14a4a";
      base09 = "#c35e0a";
      base0A = "#b47109";
      base0B = "#6c782e";
      base0C = "#4c7a5d";
      base0D = "#45707a";
      base0E = "#945e80";
      base0F = "#e78a4e";
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
      # package = pkgs.whitesur-cursors;
      # name = "WhiteSur Cursors";
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors";
      size = 24;
    };

    targets.plymouth.enable = false;
  };
}
