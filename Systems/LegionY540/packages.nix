{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    #Tools
	    ##General
	    yazi
	    unzip
	    bat
	    eza
	    stow
	    wofi
	    gparted
	    dust
	    zip
	    rar
	    keymapp
	    zathura
	    lxappearance
	    obsidian

	    numix-icon-theme-square
	    volantes-cursors
	    swww

	    ##Media
	    mpv
	    mpd
	    rmpc
	    nicotine-plus
	    gpodder
	    ffmpeg
	    ani-cli

	    ##Creative
	    gimp3
	    imagemagick

	    ##Internet
	    ungoogled-chromium
	    tor-browser
	    keepassxc

	    gpauth
	    mupdf
	    vesktop
	    ghostty
	    btop
	    lshw
	    pwvucontrol
	    tree
	    ripgrep
	    fzf
	    fd
	    filezilla
	    wl-clipboard
	    zoxide
	    neovim
	    filen-cli
	    starship

    #Utils
    uutils-coreutils-noprefix
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
	    ##C
	    gcc
	    clang
	    llvmPackages_20.clang-unwrapped
	    bear

	    ##Rust
	    cargo
	    stable.rust-analyzer
	    rustc
	    rustfmt
	    bacon
	    rusty-man
	    clippy

	    ##zig
	    zig
	    zls

	    ##python
	    python3

	    ##Go
	    go
  ];
}
