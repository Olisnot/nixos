{ pkgs, config, libs, inputs, ... }:

{
	environment.systemPackages = with pkgs; [
            #Utility
            killall
            util-linux
            htop
			lshw
			pavucontrol
			tree
            iwd
            ripgrep
            iwgtk
            opentabletdriver

			#General
			firefox
			spotify
            gnome.geary
            neofetch
            keymapp
            ranger
            wofi
            redshift
            unzip
            dunst
            flameshot
            pciutils
            element-desktop
            cinnamon.nemo
            swww
            waypaper
            mpv

			#UI
            waybar
            ags
            lxappearance
            libsForQt5.qt5ct
            libsForQt5.qtstyleplugin-kvantum
            kanagawa-gtk-theme
            kanagawa-icon-theme

			#Coding
			neovim
			git
			git-credential-manager
			tmux
			alacritty
			obsidian

			#Coding Languages
			rustc
            cargo
            rustup
            gcc
            cmake
            dotnetCorePackages.sdk_9_0
			python3
            lua

            #Art
            blender
            krita
            gimp

			#Fonts
			gnome.gucharmap
			font-awesome
			material-design-icons
            cascadia-code
	];
}
