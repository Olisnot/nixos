{ pkgs, config, libs, ... }:

{
	environment.systemPackages = with pkgs; [
			#General
			firefox
			thunderbird
			feh
            vlc
			lshw
			pavucontrol
			spotify
            spot
			tree
            iwd
            neofetch
            keymapp
            ranger
            rofi
            redshift
            unzip
            steam-run
            dunst

			#UI
			polybar
			picom
			libsForQt5.bismuth
			i3

			#Coding
			neovim
			git
			git-credential-manager
			tmux
			alacritty
			obsidian

			#Coding Languages
			dotnet-sdk_8
			rustc
            cmake
            cargo
            rustup
			python3

            #Art
            blender
            krita

			#Fonts
			gnome.gucharmap
			font-awesome
			material-design-icons
            cascadia-code
	];
}
