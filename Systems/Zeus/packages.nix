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
    localsend

    ## Appearance
    whitesur-icon-theme
    volantes-cursors
    matugen
    nwg-look

    ##Media
    playerctl
    mpv
    pear-desktop
    ffmpeg

    ##Creative
    gimp3
    imagemagick

    ##Internet
    inputs.zen-browser.packages."${system}".default

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
    gnupg

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
