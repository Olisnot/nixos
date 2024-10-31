{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    vesktop
    thunderbird
    android-studio
    unityhub
    obsidian
    gimp
    krita
    gucharmap
    chatterino2
    gpauth
    gpclient
    libreoffice-qt6-fresh
    keymapp
    mpv
    slurp
    grim
    mupdf
    waypaper
    bottles
    swww
    mpvpaper
    ags
    waybar
    openrgb-with-all-plugins
  ];
}
