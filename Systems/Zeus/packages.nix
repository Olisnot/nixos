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
    helix
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
