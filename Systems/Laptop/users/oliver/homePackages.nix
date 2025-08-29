{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    stremio
    playerctl
    amberol
    spotify
    ncspot
    #Tools
    obsidian
    gimp3
    keymapp
    gpauth
    mupdf
    waypaper
    bottles
    gucharmap
    localsend
    hydralauncher
    filen-cli
    filen-desktop
    wofi
    nwg-dock-hyprland
  ];
}
