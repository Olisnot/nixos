{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/clay-banks-u27Rrbs9Dwc-unsplash.jpg";
    polarity = "light";
    base16Scheme = {
      base00 = "#f9f9f9";
      base01 = "#e0e0e0";
      base02 = "#ababab";
      base03 = "#555555";
      base04 = "#343434";
      base05 = "#102015";
      base06 = "#040404";
      base07 = "#000000";
      base08 = "#e92f2f";
      base09 = "#e09448";
      base0A = "#dddd13";
      base0B = "#0ed839";
      base0C = "#23edda";
      base0D = "#3b48e3";
      base0E = "#f996e2";
      base0F = "#69542d";
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
