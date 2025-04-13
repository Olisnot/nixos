{ pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    image = "${inputs.wallpapers}/dark/galaxycloud.png";
    polarity = "dark";
    base16Scheme = {
        base00 = "#0f0f0f";
        base01 = "#191919";
        base02 = "#262626";
        base03 = "#4c4c4c";
        base04 = "#ac8a8c";
        base05 = "#cacaca";
        base06 = "#e7e7e7";
        base07 = "#f0f0f0";
        base08 = "#ac8a8c";
        base09 = "#ceb188";
        base0A = "#aca98a";
        base0B = "#8aac8b";
        base0C = "#8aabac";
        base0D = "#8f8aac";
        base0E = "#ac8aac";
        base0F = "#ac8a8c";
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
