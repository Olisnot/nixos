{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    stremio
    playerctl
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
    fuzzel
    hydralauncher
  ];
}
