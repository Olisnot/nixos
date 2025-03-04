{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/nord/ign_legendary.png";
    polarity = "dark";
    base16Scheme = {
      base00 = "#101010";
      base01 = "#232323";
      base02 = "#222222";
      base03 = "#333333";
      base04 = "#999999";
      base05 = "#b7b7b7";
      base06 = "#c1c1c1";
      base07 = "#d5d5d5";
      base08 = "#de6e6e";
      base09 = "#dab083";
      base0A = "#ffc799";
      base0B = "#5f8787";
      base0C = "#60a592";
      base0D = "#8eaaaa";
      base0E = "#d69094";
      base0F = "#876c4f";
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
      name = "Capitaine Cursors";
      size = 25;
    };
  };
}
