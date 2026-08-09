{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    #Tools
    ##General
    stow
    neovim
    yazi
    nemo
    zathura
    obsidian
    mupdf
    vesktop
    pwvucontrol
    filezilla
    localsend
    zmk-studio
    bluetui
    wifitui

    ## Appearance
    numix-icon-theme-square
    volantes-cursors
    nwg-look

    ##Media
    playerctl
    mpv
    feishin
    ffmpeg

    ##Creative
    gimp3
    imagemagick

    ##Internet
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    tor-browser

    ##Admin
    gpauth
    ghostty
    starship
    gparted

    ##Utils
    zoxide
    btop
    tree
    ripgrep
    fzf
    fd
    dust
    zip
    rar
    unzip
    bat
    eza
    fastfetch
    lshw
    uutils-coreutils-noprefix
    wl-clipboard
    grim
    slurp
    satty
    usbutils
    pciutils
    inetutils
    util-linux
    tree-sitter

    #Coding
    git

    nixd
    nixfmt

    #Coding Languages
    lldb

    ##Rust
    cargo
    stable.rust-analyzer
    rustc
    rustfmt
    bacon
    clippy

    ##Zig
    zig
    zig-zlint
    zls

    ##Markdown
    marksman
  ];
}
