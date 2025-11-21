{ pkgs, inputs, lib, config, ... }:

let
  nvim = inputs.nixvim.packages."x86_64-linux".default.extend {
    colorschemes.base16 = lib.mkDefault config.stylix.base16Scheme;
  };
in {
  environment.systemPackages = with pkgs; [
    #tools
    btop
    lshw
    pwvucontrol
    tree
    ripgrep
    skim
    fd
    filezilla
    wl-clipboard
    gparted
    dust
    zip
    rar
    ffmpeg
    unzip
    bat
    eza
    zoxide
    nvim

    #Utils
    uutils-coreutils-noprefix
    usbutils
    pciutils
    inetutils
    util-linux

    #General
    nautilus

    #Coding
    git
    git-credential-manager

    codex

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

    #python
    python3

    #Go
    go
  ];
}
