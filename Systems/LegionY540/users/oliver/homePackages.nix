{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    playerctl
    nicotine-plus
    lollypop
    picard
    youtube-music
    #Tools
    gimp3
    keymapp
    gpauth
    mupdf
    waypaper
    gucharmap
    localsend
    yazi
    imagemagick
    vesktop
    librewolf-bin
  ];
}
