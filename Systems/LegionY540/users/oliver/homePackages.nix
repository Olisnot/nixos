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
    gucharmap
    localsend
    yazi
    imagemagick
    vesktop
    tor-browser
    bitwarden-desktop
  ];
}
