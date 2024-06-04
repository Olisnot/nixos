{ pkgs, config, libs, ... }:

{
	environment.systemPackages = with pkgs; [
			#General
			firefox
			thunderbird
			feh
            htop
            vlc
			lshw
			pavucontrol
			spotify
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
            flameshot
            pciutils
            element-desktop
            cinnamon.nemo

			#UI
			polybar
			picom
			i3
            eww
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
