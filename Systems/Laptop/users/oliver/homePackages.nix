{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    miru
    stremio
    playerctl
    tidal-hifi
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
  ];
}
