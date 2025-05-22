{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #tools
    xwayland-satellite
    btop
    lshw
    pwvucontrol
    tree
    iwd
    iwgtk
    ripgrep
    blueman
    fzf
    skim
    fd
    filezilla
    wl-clipboard
    gparted
    zip
    ffmpeg
    unzip

    #Utils
    uutils-coreutils-noprefix
    usbutils
    pciutils
    inetutils
    util-linux

    #General
    yazi
    wofi

    #Coding
    git
    git-credential-manager

    #Coding Languages
    gcc
    python314
    cargo 
    rustc 
    rustfmt 
    rusty-man
    clippy
  ];
}
