{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
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
    gucharmap
    #social
    equibop
    zapzap
  ];
}
