{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    grayjay
    streamlink
    streamlink-twitch-gui-bin 
    chatterino2
    miru
    playerctl
    tidal-hifi
    tidal-dl
    #Tools
    obsidian
    nautilus
    gimp3
    krita
    gucharmap
    keymapp
    gpauth
    mupdf
    waypaper
    bottles
    swww
    fuzzel
    #Social
    vesktop
    equibop
  ];
}
