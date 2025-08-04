{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    stremio
    playerctl
    youtube-music
    tidal-dl
    #Tools
    obsidian
    gimp3
    keymapp
    gpauth
    mupdf
    waypaper
    bottles
    swww
    gucharmap
    localsend
    #social
    equibop
    revolt-desktop
    element-desktop
  ];
}
