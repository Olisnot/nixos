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
    zed-editor
    yazi
    nemo
    keymapp
    zathura
    obsidian
    mupdf
    vesktop
    pwvucontrol
    filezilla

    ## Appearance
    numix-icon-theme-square
    whitesur-icon-theme
    volantes-cursors
    matugen
    nwg-look

    ##Media
    playerctl
    mpv
    youtube-music
    nicotine-plus
    ffmpeg
    ani-cli

    ##Creative
    gimp3
    imagemagick

    ##Internet
    inputs.zen-browser.packages."${system}".default
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
    usbutils
    pciutils
    inetutils
    util-linux

    #Coding
    git
    git-credential-manager

    texlab
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
    rusty-man
    clippy

    ##Go
    go
    gopls
    gofumpt

    ##zig
    zig
    zls

    ##python
    python3
    ty
    uv
    black

    ##C
    gcc
    clang
    llvmPackages_20.clang-unwrapped
    bear

    ##C-sharp
    dotnet-sdk_8
    omnisharp-roslyn
    csharpier

    ##Lua
    lua
    lua-language-server
    stylua

    ##Markdown
    marksman
  ];
}
