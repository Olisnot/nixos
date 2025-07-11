{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #tools
    btop
    lshw
    pwvucontrol
    tree
    iwd
    iwgtk
    ripgrep
    blueman
    skim
    fd
    filezilla
    wl-clipboard
    gparted
    zip
    ffmpeg
    unzip
    bat
    eza
    zoxide

    #Utils
    uutils-coreutils-noprefix
    usbutils
    pciutils
    inetutils
    util-linux

    #General
    yazi
    wofi

    #gnome extensions
    gnomeExtensions.dock-from-dash
    gnomeExtensions.media-controls
    gnomeExtensions.logo-menu
    nautilus

    #Coding
    git
    git-credential-manager

    #Coding Languages
    lldb
    #C
    gcc
    clang
    llvmPackages_20.clang-unwrapped
    bear

    #Rust
    cargo 
    rust-analyzer
    rustc 
    rustfmt 
    bacon
    rusty-man
    clippy

    #zig
    zig
    zls
    
    #Python
    python314
  ];
}
