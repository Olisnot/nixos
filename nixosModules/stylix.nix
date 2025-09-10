{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/clay-banks-u27Rrbs9Dwc-unsplash.jpg";
    polarity = "light";
    base16Scheme = {
      base00 = "#FAFAFA";
      base01 = "#E7EAEC";
      base02 = "#CCEAE7";
      base03 = "#CCD7DA";
      base04 = "#8796B0";
      base05 = "#80CBC4";
      base06 = "#80CBC4";
      base07 = "#FFFFFF";
      base08 = "#FF5370";
      base09 = "#F76D47";
      base0A = "#FFB62C";
      base0B = "#91B859";
      base0C = "#39ADB5";
      base0D = "#6182B8";
      base0E = "#7C4DFF";
      base0F = "#E53935";
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
