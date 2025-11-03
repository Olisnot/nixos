{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    stremio
    playerctl
    nicotine-plus
    lollypop
    picard
    #Tools
    gimp3
    keymapp
    gpauth
    mupdf
    waypaper
    gucharmap
    localsend
    yazi
  ];
}
