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
            cmake
            cargo
            rustup
			python3
            gcc

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
