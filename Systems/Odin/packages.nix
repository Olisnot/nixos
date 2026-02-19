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
	    wofi
	    keymapp
	    zathura
	    obsidian
	    waybar
	    mupdf
	    dunst
	    vesktop
	    pwvucontrol
	    filezilla

	    ## Appearance
	    numix-icon-theme-square
	    volantes-cursors
	    swww
	    tinty
	    nwg-look

	    ##Media
	    mpv
	    mpd
	    mpd-notification
	    rmpc
	    nicotine-plus
	    ffmpeg
	    ani-cli

	    ##Creative
	    gimp3
	    imagemagick

	    ##Internet
	    ungoogled-chromium
	    tor-browser
	    keepassxc

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

	    ##zig
	    zig
	    zls

	    ##python
	    python3
	    ty

	    ##C
	    gcc
	    clang
	    llvmPackages_20.clang-unwrapped
	    bear

	    ##C-sharp
	    dotnet-sdk_8
	    omnisharp-roslyn
  ];
}
