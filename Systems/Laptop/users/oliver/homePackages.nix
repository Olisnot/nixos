{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #Media
    mpv
    stremio
    playerctl
    nicotine-plus
    lollypop
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
    hydralauncher
    filen-cli
    filen-desktop
    wofi
    lmstudio
  ];
}
