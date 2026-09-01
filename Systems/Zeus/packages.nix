{
  pkgs,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  environment.systemPackages = with pkgs; [
    #Tools
    ##General
    stow
    neovim
    yazi
    nemo
    zathura
    mupdf
    vesktop
    pwvucontrol
    filezilla
    localsend
    zmk-studio
    bluetui
    wifitui
    zk
    obsidian

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
    inputs.zen-browser.packages.${system}.default
    ungoogled-chromium
    librewolf
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
    # zip
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

    ##AI
    opencode
    pi-coding-agent
    herdr

    nixd
    nixfmt

    #Coding Languages
    lldb
    nodejs

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
