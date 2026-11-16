{
  pkgs,
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
    mupdf
    vesktop
    pwvucontrol
    filezilla
    localsend
    zmk-studio
    bluetui
    wifitui
    obsidian
    qbittorrent

    ## Appearance
    numix-icon-theme-square
    whitesur-icon-theme
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
    gcc

    ##AI
    pi-coding-agent
    opencode
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
