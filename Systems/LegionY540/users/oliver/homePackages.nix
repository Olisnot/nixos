{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    playerctl
    nicotine-plus
    lollypop
    picard
    pear-desktop
    gpodder
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
  ];
}
