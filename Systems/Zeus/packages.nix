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
    helix
    zed-editor
    yazi
    nemo
    keymapp
    zathura
    obsidian
    mupdf
    discord
    pwvucontrol
    filezilla
    localsend
    tutanota-desktop
    zmk-studio
    bluetui
    wifitui
    gnome-calendar

    ## Appearance
    whitesur-icon-theme
    papirus-icon-theme
    tela-icon-theme
    numix-icon-theme-square
    volantes-cursors
    nwg-look

    ##Media
    playerctl
    mpv
    pear-desktop
    gelly
    ffmpeg

    ##Creative
    gimp3
    imagemagick

    ##Internet
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ungoogled-chromium
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
    git-credential-manager

    texlab
    nixd
    nixfmt

    opencode

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
