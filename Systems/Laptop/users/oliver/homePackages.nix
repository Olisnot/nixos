{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    nautilus
    obsidian
    gimp
    krita
    gucharmap
    chatterino2
    gpauth
    libreoffice-qt6-fresh
    keymapp
    mpv
    slurp
    grim
    mupdf
    waypaper
    bottles
    swww
    waybar
    globalprotect-openconnect
    pomodoro-gtk
    ani-cli
  ];
}
