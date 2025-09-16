{ pkgs, inputs, ... }:

let nvim = inputs.nixvim.packages."x86_64-linux".default;
in {
  environment.systemPackages = with pkgs; [
    #tools
    btop
    lshw
    pwvucontrol
    tree
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
    mullvad-vpn
    xwayland-satellite
    networkmanagerapplet
    nvim

    #Utils
    uutils-coreutils-noprefix
    usbutils
    pciutils
    inetutils
    util-linux

    #General
    yazi
    nautilus

    #Coding
    git
    git-credential-manager

    texlab
    nixd
    nixfmt-classic

    #Coding Languages
    lldb
    #C
    gcc
    clang
    llvmPackages_20.clang-unwrapped
    bear

    #Rust
    cargo
    stable.rust-analyzer
    rustc
    rustfmt
    bacon
    rusty-man
    clippy

    #zig
    zig
    zls
  ];
}
