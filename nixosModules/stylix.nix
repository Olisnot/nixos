{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/gruvbox/18.png";
    polarity = "dark";
    base16Scheme = {
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
      name = "Capitaine Cursors (Gruvbox)";
      size = 25;
    };
  };
}
