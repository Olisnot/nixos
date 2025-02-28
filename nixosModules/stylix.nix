{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/nord/ign_legendary.png";
    polarity = "dark";
    base16Scheme = {
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

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
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
      name = "Capitaine Cursors (Nord)";
      size = 25;
    };
  };
}
