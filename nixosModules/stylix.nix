{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/clay-banks-u27Rrbs9Dwc-unsplash.jpg";
    polarity = "dark";
    base16Scheme = {
      base00 = "#212121";
      base01 = "#303030";
      base02 = "#353535";
      base03 = "#4A4A4A";
      base04 = "#B2CCD6";
      base05 = "#EEFFFF";
      base06 = "#EEFFFF";
      base07 = "#FFFFFF";
      base08 = "#F07178";
      base09 = "#F78C6C";
      base0A = "#FFCB6B";
      base0B = "#C3E88D";
      base0C = "#89DDFF";
      base0D = "#82AAFF";
      base0E = "#C792EA";
      base0F = "#FF5370";
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
