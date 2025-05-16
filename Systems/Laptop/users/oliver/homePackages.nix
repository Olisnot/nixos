{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vesktop
    equibop
    nautilus
    obsidian
    gimp3
    krita
    gucharmap
    streamlink
    streamlink-twitch-gui-bin 
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
    miru
    playerctl
    tidal-hifi
    librewolf-bin
  ];
}
